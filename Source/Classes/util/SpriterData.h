#import "cocos2d.h"

@class TGSpriterAnimation;
@class TGSpriterFile;

@protocol SpriteSheetReader <NSObject>
-(CGRect)cgRectForFrame:(NSString*)key;
-(CCTexture*)texture;
-(NSString*)filepath;
@end

@interface SpriterData : NSObject
+(SpriterData*)cons_data_from_spritesheetreaders:(NSArray*)sheetreaders scml:(NSString*)scml;
-(NSDictionary*)folders;
-(NSDictionary*)animations;
-(TGSpriterAnimation*)anim_of_name:(NSString*)name;
-(TGSpriterFile*)file_for_folderid:(int)folderid fileid:(int)fileid;

-(void)replace_atlas_index:(int)index with:(id<SpriteSheetReader>)tar;

@end
