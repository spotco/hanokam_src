//
//  SPStrokeNumberLabel.h
//  hanokam
//
//  Created by spotco on 16/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SPLabel : CCNode

+(SPLabel*)cons_texkey:(NSString*)texkey;
-(SPLabel*)set_fill:(ccColor4F)fillcolor stroke:(ccColor4F)strokecolor shadow:(ccColor4F)shadowcolor;
-(SPLabel*)set_string:(NSString*)string;

-(void)markup_string:(NSString*)markup_string out_display_string:(NSString**)out_display_string out_style_map:(NSDictionary**)out_style_map;

@end
