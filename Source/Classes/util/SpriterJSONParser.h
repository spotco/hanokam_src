#import "SpriterData.h"

@interface SpriterJSONParser : NSObject <SpriteSheetReader>
+(SpriterJSONParser*)cons_texture:(CCTexture*)tex file:(NSString*)filepath;
-(SpriterJSONParser*)parseFile:(NSString*)filepath;
-(CCTexture*)texture;
-(NSString*)filepath;
-(CGRect)cgRectForFrame:(NSString*)key;
@end
