//
//  SPStrokeNumberLabel.m
//  hanokam
//
//  Created by spotco on 16/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPLabel.h"
#import "Resource.h"
#import "CCLabelBMFont.h"
#import "CCLabelBMFont_Private.h"
#import "Common.h"
#import "ShaderManager.h"
#import "ObjectPool.h"

@implementation SPLabelStyle
+(SPLabelStyle*)cons {
	return [[[SPLabelStyle alloc] init] cons];
}
-(SPLabelStyle*)cons {
	self._stroke = GLKVector4Make(0, 0, 0, 0);
	self._fill = GLKVector4Make(0, 0, 0, 1);
	self._shadow = GLKVector4Make(0, 0, 0, 0);
	self._amplitude = 0;
	self._time_incr = 0.5;
	return self;
}
-(SPLabelStyle*)set_fill:(ccColor4F)fillcolor stroke:(ccColor4F)strokecolor shadow:(ccColor4F)shadowcolor {
	self._fill = GLKVector4Make(fillcolor.r, fillcolor.g, fillcolor.b, fillcolor.a);
	self._stroke = GLKVector4Make(strokecolor.r, strokecolor.g, strokecolor.b, strokecolor.a);
	self._shadow = GLKVector4Make(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a);
	return self;
}
@end

@interface SPLabelCharacter : CCSprite
-(SPLabelCharacter*)cons_tex:(CCTexture*)tex rect:(CGRect)rect;
-(void)set_style:(SPLabelStyle*)style;
-(void)i_update:(float)time;
-(float)get_time_incr;
@end

@implementation SPLabelCharacter {
	CGPoint _start_position;
	float _amplitude;
	float _time_incr;
}

-(SPLabelCharacter*)cons_tex:(CCTexture*)tex rect:(CGRect)rect {
	[self setTexture:tex];
	[self setTextureRect:rect];
	_start_position = CGPointZero;
	return self;
}

-(void)set_style:(SPLabelStyle *)style {
	self.shaderUniforms[@"fill_color"] = [NSValue valueWithGLKVector4:style._fill];
	self.shaderUniforms[@"stroke_color"] = [NSValue valueWithGLKVector4:style._stroke];
	self.shaderUniforms[@"shadow_color"] = [NSValue valueWithGLKVector4:style._shadow];
	_amplitude = style._amplitude;
	_time_incr = style._time_incr;
}

-(void)i_update:(float)time {
	CGPoint offset = ccp(0,_amplitude*sinf(time));
	[super setPosition:CGPointAdd(_start_position, offset)];
}

-(float)get_time_incr {
	return _time_incr;
}

-(void)setPosition:(CGPoint)position {
	_start_position = position;
	[super setPosition:_start_position];
}

@end

@implementation SPLabel {
	NSString *_texkey;
	NSMutableArray *_characters;
	GLKVector4 _fillcolor, _strokecolor, _shadowcolor;
	
	NSString *_cached_string;
	
	SPLabelStyle *_default_style;
	NSMutableDictionary *_name_to_styles;
	
	CCBMFontConfiguration *_bmfont_cfg;
	float _time;
}
+(SPLabel*)cons_texkey:(NSString*)texkey {
	return [[SPLabel node] cons_texkey:texkey];
}
-(SPLabel*)cons_texkey:(NSString*)texkey {
	_texkey = texkey;
	_characters = [NSMutableArray array];
	_bmfont_cfg = FNTConfigLoadFile([NSString stringWithFormat:@"%@.fnt",_texkey]);
	_cached_string = @"";
	_default_style = [SPLabelStyle cons];
	_name_to_styles = [NSMutableDictionary dictionary];
	return self;
}

-(SPLabel*)set_default_fill:(ccColor4F)fillcolor stroke:(ccColor4F)strokecolor shadow:(ccColor4F)shadowcolor {
	[_default_style set_fill:fillcolor stroke:strokecolor shadow:shadowcolor];
	[self set_string:_cached_string];
	return self;
}

-(void)set_default_style:(SPLabelStyle*)style {
	_default_style = style;
}

-(void)add_style:(SPLabelStyle*)style name:(NSString*)name {
	_name_to_styles[name] = style;
}

-(void)update:(CCTime)delta {
	float itr_time = _time;
	_time += delta;
	for (int i = 0; i < _characters.count; i++) {
		SPLabelCharacter *itr = _characters[i];
		[itr i_update:itr_time];
		itr_time += [itr get_time_incr];
	}
}

-(void)markup_string:(NSString*)markup_string out_display_string:(NSString**)out_display_string out_style_map:(NSDictionary**)out_style_map {
	NSMutableString *rtv_display_string = [NSMutableString stringWithString:@""];
	NSMutableDictionary *rtv_style_map = [NSMutableDictionary dictionary];
	NSMutableString *current_style = [NSMutableString stringWithString:@""];
	BOOL in_tag_mode = NO;
	
	for (int i = 0; i < markup_string.length; i++) {
		unichar itr = [markup_string characterAtIndex:i];
		switch (itr) {
			case '[':{
				in_tag_mode = YES;
				[current_style setString:@""];
				
			} break;
			case ']' : {
				in_tag_mode = NO;
				
			} break;
			case '@' : {
				[current_style setString:@""];
				
			} break;
			default : {
				if (in_tag_mode) {
					[current_style appendString:[NSString stringWithCharacters:&itr length:1]];
					
				} else {
					[rtv_display_string appendString:[NSString stringWithCharacters:&itr length:1]];
					[rtv_style_map setObject:[NSString stringWithString:current_style] forKey:@(rtv_display_string.length-1)];
					
				}
			} break;
		}
	}
	*out_display_string = rtv_display_string;
	*out_style_map = rtv_style_map;
}

-(SPLabel*)set_string:(NSString *)markup_string {
	for (SPLabelCharacter *itr in _characters) {
		[self removeChild:itr];
		[ObjectPool repool:itr class:[SPLabelCharacter class]];
	}
	[_characters removeAllObjects];
	_cached_string = markup_string;
	
	NSString *display_string;
	NSDictionary *style_map;
	if ([markup_string containsString:@"["]) {
		[self markup_string:markup_string out_display_string:&display_string out_style_map:&style_map];
	} else {
		display_string = markup_string;
	}
	
	//SEE: CCLabelBMFont.m
	NSInteger nextFontPositionX = 0;
	NSInteger nextFontPositionY = 0;
	unichar prev = -1;
	NSInteger kerningAmount = 0;
    
	NSInteger longestLine = 0;
	NSUInteger totalHeight = 0;
    
	NSUInteger quantityOfLines = 1;
	
	NSCharacterSet *charSet	= _bmfont_cfg.characterSet;
    
	NSUInteger stringLen = [display_string length];
	if (stringLen == 0) return self;
	
	for(NSUInteger i=0; i < stringLen-1;i++) {
		unichar c = [display_string characterAtIndex:i];
		if([[NSCharacterSet newlineCharacterSet] characterIsMember:c])
			quantityOfLines++;
	}
    
	totalHeight = _bmfont_cfg->_commonHeight * quantityOfLines;
	nextFontPositionY = -(_bmfont_cfg->_commonHeight - _bmfont_cfg->_commonHeight*quantityOfLines);
    CGRect rect;
    ccBMFontDef fontDef = (ccBMFontDef){};
	
	CGFloat contentScale = 1.0/[Resource get_tex:_texkey].contentScale;
	
	for(NSUInteger i = 0; i<stringLen; i++) {
		unichar c = [display_string characterAtIndex:i];
        
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:c]) {
			nextFontPositionX = 0;
			nextFontPositionY -= _bmfont_cfg->_commonHeight;
			continue;
		}
    
		if(![charSet characterIsMember:c]){
			CCLOGWARN(@"cocos2d: CCLabelBMFont: Attempted to use character not defined in this bitmap: %C", c);
			continue;
		}
        
		kerningAmount = [self kerningAmountForFirst:prev second:c];
		
		tCCFontDefHashElement *element = NULL;
		
		NSUInteger key = (NSUInteger)c;
		HASH_FIND_INT(_bmfont_cfg->_fontDefDictionary , &key, element);
		if( ! element ) {
			CCLOGWARN(@"cocos2d: CCLabelBMFont: characer not found %c", c);
			continue;
		}
		
		fontDef = element->fontDef;
		
		rect = CC_RECT_SCALE(fontDef.rect, contentScale);
		SPLabelCharacter *neu_digit_spr = [ObjectPool depool:[SPLabelCharacter class]];
		[neu_digit_spr cons_tex:[Resource get_tex:_texkey] rect:rect];
		[neu_digit_spr setShader:[ShaderManager get_shader:SHADER_STROKE_FILL_TEXT]];
		
		SPLabelStyle *itr_style;
		if (style_map != NULL) itr_style = [_name_to_styles objectForKey:[style_map objectForKey:@(i)]];
		if (itr_style != NULL) {
			[neu_digit_spr set_style:itr_style];
		} else {
			[neu_digit_spr set_style:_default_style];
		}
		
		[self addChild:neu_digit_spr];
		[_characters addObject:neu_digit_spr];
		
		NSInteger yOffset = _bmfont_cfg->_commonHeight - fontDef.yOffset;
		CGPoint fontPos = ccp( (CGFloat)nextFontPositionX + fontDef.xOffset + fontDef.rect.size.width*0.5f + kerningAmount,
							  (CGFloat)nextFontPositionY + yOffset - rect.size.height*0.5f * neu_digit_spr.texture.contentScale );
		neu_digit_spr.position = ccpMult(fontPos, contentScale);
		
		nextFontPositionX += fontDef.xAdvance + kerningAmount;
		prev = c;
		
		if (longestLine < nextFontPositionX) longestLine = nextFontPositionX;
	}
	
	CGSize tmpSize = CGSizeZero;
    if (fontDef.xAdvance < fontDef.rect.size.width) {
        tmpSize.width = longestLine + fontDef.rect.size.width - fontDef.xAdvance;
    } else {
        tmpSize.width = longestLine;
    }
    tmpSize.height = totalHeight;
    
	[self setContentSize:CC_SIZE_SCALE(tmpSize, contentScale)];
	return self;
}

-(int) kerningAmountForFirst:(unichar)first second:(unichar)second
{
	int ret = 0;
	unsigned int key = (first<<16) | (second & 0xffff);
    
	if( _bmfont_cfg->_kerningDictionary ) {
		tCCKerningHashElement *element = NULL;
		HASH_FIND_INT(_bmfont_cfg->_kerningDictionary, &key, element);
		if(element)
			ret = element->amount;
	}
    
	return ret;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
	[super setAnchorPoint:anchorPoint];
	[self set_string:_cached_string];
}

@end
