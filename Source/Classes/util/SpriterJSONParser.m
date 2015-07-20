//
//  SpriterJSONParser.m
//  hobobob
//
//  Created by spotco on 17/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SpriterJSONParser.h"


@interface SpriterJSONFrame : NSObject
@property(readwrite,assign) CGRect val;
@end

@implementation SpriterJSONFrame
@synthesize val;
+(SpriterJSONFrame*)fromCGRect:(CGRect)rect {
	SpriterJSONFrame *rtv = [[SpriterJSONFrame alloc] init];
	rtv.val = rect;
	return rtv;
}
@end

@implementation SpriterJSONParser {
	NSMutableDictionary *_frames;
	CCTexture *_texture;
	NSString *_filepath;
}

+(SpriterJSONParser*)cons_texture:(CCTexture*)tex file:(NSString*)filepath {
	return [[[SpriterJSONParser alloc] init] cons_texture:tex file:filepath];
}

-(SpriterJSONParser*)cons_texture:(CCTexture*)tex file:(NSString*)filepath {
	_texture = tex;
	_filepath = filepath;
	[self parseFile:filepath];
	return self;
}

-(CCTexture*)texture {
	return _texture;
}
-(NSString*)filepath {
	return _filepath;
}

-(SpriterJSONParser*)parseFile:(NSString*)filepath {
	_frames = [NSMutableDictionary dictionary];

	NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:filepath];
	NSData *jsonData = [NSData dataWithContentsOfFile:path];
	
	NSError *error = nil;
	NSDictionary *root = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
	NSDictionary *frames = root[@"frames"];
	for (NSString* key in frames) {
		NSDictionary *frame = frames[key][@"frame"];
		NSDictionary *sprite_source_size = frames[key][@"spriteSourceSize"];
		NSDictionary *source_size = frames[key][@"sourceSize"];
		
		//hack in TexturePacker trim model, this won't actually work if it clips another spritesheet image
		#define dict_val(_dict,_dictkey) (((NSNumber*)_dict[_dictkey]).intValue)
		CGRect rect = CGRectMake(
			dict_val(frame, @"x") - dict_val(sprite_source_size, @"x"),
			dict_val(frame, @"y") - dict_val(sprite_source_size, @"y"),
			dict_val(source_size, @"w"),
			dict_val(source_size, @"h"));
		#undef dict_val
		_frames[key] = [SpriterJSONFrame fromCGRect:rect];
	}
	return self;
}

-(CGRect)cgRectForFrame:(NSString*)key {
	SpriterJSONFrame *rtv = _frames[key];
	return rtv.val;
}

@end
