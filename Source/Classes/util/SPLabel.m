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

@implementation SPLabel {
	NSString *_texkey;
	NSMutableArray *_characters;
	NSMutableArray *_unused_pool;
	GLKVector4 _fillcolor, _strokecolor;
	
	NSMutableDictionary *_char_tsizei;
	NSMutableDictionary *_char_offset;
	
	BOOL _right_aligned;
}
+(SPLabel*)cons_texkey:(NSString*)texkey {
	return [[SPLabel node] cons_texkey:texkey];
}
-(SPLabel*)cons_texkey:(NSString*)texkey {
	_texkey = texkey;
	_characters = [NSMutableArray array];
	_unused_pool = [NSMutableArray array];
	_char_tsizei = [NSMutableDictionary dictionary];
	_char_offset = [NSMutableDictionary dictionary];
	_right_aligned = NO;
	return self;
}

-(SPLabel*)set_fillcolor:(ccColor4F)fillcolor strokecolor:(ccColor4F)strokecolor {
	_fillcolor = GLKVector4Make(fillcolor.r, fillcolor.g, fillcolor.b, fillcolor.a);
	_strokecolor = GLKVector4Make(strokecolor.r, strokecolor.g, strokecolor.b, strokecolor.a);
	return self;
}

-(SPLabel*)set_string:(NSString *)string {
	[_unused_pool addObjectsFromArray:_characters];
	[_characters removeAllObjects];
	[self removeAllChildren];
	
	CCBMFontConfiguration *bmfont_cfg = FNTConfigLoadFile([NSString stringWithFormat:@"%@.fnt",_texkey]);
	float layout_x = 0;
	for(long i = _right_aligned?string.length-1:0; _right_aligned?i>=0:i<string.length; _right_aligned?i--:i++) {
		unichar c = [string characterAtIndex:i];
		tCCFontDefHashElement *element = NULL;
		NSUInteger key = (NSUInteger)c;
		HASH_FIND_INT(bmfont_cfg->_fontDefDictionary , &key, element);
		if(!element) {
			NSLog(@"SPLabel: CCLabelBMFont: characer not found %c", c);
			continue;
		}
		CGRect bounds = element->fontDef.rect;
		
		NSNumber *char_key = [NSNumber numberWithUnsignedShort:c];
		CGPoint size_increase = ((NSValue*)_char_tsizei[char_key]).CGPointValue;
		CGPoint offset = ((NSValue*)_char_offset[char_key]).CGPointValue;
		
		CCSprite *neu_digit_spr = [self get_char_from_pool];
		[neu_digit_spr setTexture:[Resource get_tex:_texkey]];
		[neu_digit_spr setTextureRect:bounds];
		[neu_digit_spr setShader:[ShaderManager get_shader:SHADER_STROKE_FILL_TEXT]];
		neu_digit_spr.shaderUniforms[@"fill_color"] = [NSValue valueWithGLKVector4:_fillcolor];
		neu_digit_spr.shaderUniforms[@"stroke_color"] = [NSValue valueWithGLKVector4:_strokecolor];
		[self addChild:neu_digit_spr];
		
		if (_right_aligned) {
			[neu_digit_spr setPosition:ccp(layout_x + offset.x - (bounds.size.width + size_increase.x),offset.y)];
			layout_x -= bounds.size.width + size_increase.x;
		} else {
			[neu_digit_spr setPosition:ccp(layout_x + offset.x,offset.y)];
			layout_x += bounds.size.width + size_increase.x;
		}
	}
	return self;
}

-(SPLabel*)set_right_aligned {
	_right_aligned = YES;
	return self;
}

-(SPLabel*)add_char_offset:(unichar)tchar size_increase:(CGPoint)tsizei offset:(CGPoint)toffset {
	NSNumber *key = [NSNumber numberWithUnsignedShort:tchar];
	_char_tsizei[key] = [NSValue valueWithCGPoint:tsizei];
	_char_offset[key] = [NSValue valueWithCGPoint:toffset];
	return self;
}

-(CCSprite*)get_char_from_pool {
	if (_unused_pool.count > 0) {
		CCSprite *rtv = [_unused_pool objectAtIndex:0];
		[_unused_pool removeObjectAtIndex:0];
		return rtv;
	} else {
		return [CCSprite node];
	}
}

@end
