#import "Common.h"
#import "GameMain.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "CoreFoundation/CoreFoundation.h"
#import "CCTexture_Private.h"
#import "CCAnimation.h"
#import "Resource.h"
#import "FileCache.h"
#import "DataStore.h"
#import "md5.h"

@implementation NSString (md5)
-(long)md5 {
    const char* cStr = [self UTF8String];
    unsigned char result[16];
	MD5_CTX md5_ctx;
	MD5_Init(&md5_ctx);
	MD5_Update(&md5_ctx, cStr, strlen(cStr));
	MD5_Final(result, &md5_ctx);
    return *((long*)result);
}
@end

@implementation CCSprite_Animated
@synthesize _current_anim;
-(void)update_playAnim:(CCAction*)anim {
	if (anim != _current_anim) {
		[self stopAllActions];
		[self runAction:anim];
	}
	_current_anim = anim;
}

@end

@implementation CallBack
	@synthesize selector;
	@synthesize target;
@end

@implementation GLRenderObject
    @synthesize isalloc,pts;
    @synthesize texture;
	@synthesize transform;
    -(fCGPoint*)tex_pts {return tex_pts;}
    -(fCGPoint*)tri_pts {return tri_pts;}
@end

@implementation TexRect
	@synthesize tex;
	@synthesize rect;
+(TexRect*)cons_tex:(CCTexture *)tex rect:(CGRect)rect {
    TexRect *r = [[TexRect alloc] init]; [r setTex:tex]; [r setRect:rect]; return r;
}
@end

@implementation CCNode (helpers)
-(CCNode*)set_pos:(CGPoint)pt {
	[self setPosition:pt];
	return self;
}
-(CCNode*)set_scale:(float)scale {
	[self setScale:scale];
	return self;
}
-(CCNode*)set_scale_x:(float)scale_x {
	[self setScaleX:scale_x];
	return self;
}
-(CCNode*)set_scale_y:(float)scale_y {
	[self setScaleY:scale_y];
	return self;
}
-(CCNode*)set_rotation:(float)rotation {
	[self setRotation:rotation];
	return self;
}
-(CCNode*)set_color:(ccColor3B)color {
	[self setColor:[CCColor colorWithCcColor3b:color]];
	return self;
}
-(CCNode*)set_visible:(BOOL)visible {
	[self setVisible:visible];
	return self;
}
-(CCNode*)set_anchor_pt:(CGPoint)pt {
	[self setAnchorPoint:pt];
	return self;
}
-(CCNode*)add_to:(CCNode*)parent {
	return [self add_to:parent z:0];
}
-(CCNode*)add_to:(CCNode*)parent z:(NSInteger)z {
	[parent addChild:self z:z];
	return self;
}
-(CCNode*)add_on:(CCNode*)child {
	[self addChild:child];
	return self;
}
@end

@implementation NSArray (Random)
-(id)random {
	uint32_t rnd = (uint32_t)arc4random_uniform((u_int32_t)[self count]);
	return [self objectAtIndex:rnd];
}
-(BOOL)contains_str:(NSString *)tar {
	for (id i in self) {
		if ([i isEqualToString:tar]) return YES;
	}
	return NO;
}
-(NSArray*)copy_removing:(NSArray *)a {
	NSMutableArray *n = [NSMutableArray array];
	for (id i in self) {
		if (![a containsObject:i]) [n addObject:i];
	}
	return n;
}
-(id)get:(int)i {
	if (i >= [self count]) {
		return NULL;
	} else {
		return [self objectAtIndex:i];
	}
}
@end

@implementation NSDictionary (KeySet)
-(NSMutableSet*)keySet {
	NSMutableArray *rtv = [NSMutableArray array];
	for (id obj in [self keyEnumerator]) {
		[rtv addObject:obj];
	}
	return [NSMutableSet setWithArray:rtv];
}
@end

float drp(float a, float b, float div) {
	return a + (b - a) / div;
}

float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}

CGPoint lerp_point(CGPoint a, CGPoint b, float t) {
	return ccp(lerp(a.x, b.x, t),lerp(a.y, b.y, t));
}

long sys_time() {
	return CFAbsoluteTimeGetCurrent();
}

fCGPoint fCGPointMake(float x, float y){
	fCGPoint rtv;
	rtv.x = x;
	rtv.y = y;
	return rtv;
}

@implementation NSMutableArray (Shuffle)
-(void)shuffle {
	for (NSUInteger i = [self count] - 1; i >= 1; i--){
		u_int32_t j = (uint32_t)arc4random_uniform((u_int32_t)i + 1);
		[self exchangeObjectAtIndex:j withObjectAtIndex:i];
	}
}
-(id)add:(id)i {
	[self addObject:i];
	return i;
}
@end

CGRange CGRangeMake(float min, float max) {
	return (CGRange){min,max};
}

CGRect cctexture_default_rect(CCTexture *tex) {
	return CGRectMake(0, 0, tex.pixelWidth, tex.pixelHeight);
}

NSString* strf (char* format, ... ) {
    char outp[255];
    va_list a_list;
    va_start( a_list, format );
    vsprintf(outp, format, a_list);
    va_end(a_list);
    return [NSString stringWithUTF8String:outp];
}

int SIG(float n) {
    if (n > 0) {
        return 1;
    } else if (n < 0) {
        return -1;
    } else {
        return 0;
    }
}

CGPoint CGPointAdd(CGPoint a,CGPoint b) {
    return ccp(a.x+b.x,a.y+b.y);
}
CGPoint CGPointSub(CGPoint a,CGPoint b) {
    return ccp(a.x-b.x,a.y-b.y);
}
float CGPointDist(CGPoint a,CGPoint b) {
    return sqrtf(powf(a.x-b.x, 2)+powf(a.y-b.y, 2));
}
CGPoint CGPointMid(CGPoint a,CGPoint b) {
	CGPoint add = CGPointAdd(a, b);
	return ccp(add.x/2,add.y/2);
}

bool fuzzyeq(float a, float b, float delta) {
	return ABS(a-b) <= delta;
}

float deg_to_rad(float degrees) {
    return degrees * M_PI / 180.0;
}

float rad_to_deg(float rad) {
    return rad * 180.0 / M_PI;
}

CGPoint pct_of_obj(CCNode* obj, float pctx, float pcty) {
	CGRect rct = [obj boundingBox];
	return ccp(rct.size.width*pctx*1/ABS(obj.scaleX),rct.size.height*pcty*1/ABS(obj.scaleY));
}

static BOOL has_set_sdt = NO;
static CCTime sdt = 1;
static CCTime last_sdt = 1;
void dt_set(CCTime dt) {
	if (!has_set_sdt) {
		has_set_sdt = YES;
		sdt = dt;
		last_sdt = dt;
		return;
	}

	last_sdt = sdt;
	sdt = dt;
	if (ABS(sdt-last_sdt) > 0.01) {
		sdt = last_sdt + 0.01 * SIG(sdt-last_sdt);
	}
}

void dt_unset() {
	has_set_sdt = NO;
}

float dt_scale_get() {
	return clampf(sdt/(1/60.0f), 0.25, 3);
}

CGSize game_screen() {
    return [CCDirector sharedDirector].viewSize;
}

CGPoint game_screen_pct(float pctwid, float pcthei) {
    return ccp(game_screen().width*pctwid,game_screen().height*pcthei);
}

CGPoint game_screen_anchor_offset(ScreenAnchor anchor, CGPoint offset) {
	CGPoint rtv;
	switch (anchor) {
		case ScreenAnchor_BL: rtv = game_screen_pct(0, 0); break;
		case ScreenAnchor_BM: rtv = game_screen_pct(0.5, 0); break;
		case ScreenAnchor_BR: rtv = game_screen_pct(1, 0); break;
		case ScreenAnchor_ML: rtv = game_screen_pct(0, 0.5); break;
		case ScreenAnchor_MM: rtv = game_screen_pct(0.5, 0.5); break;
		case ScreenAnchor_MR: rtv = game_screen_pct(1, 0.5); break;
		case ScreenAnchor_TL: rtv = game_screen_pct(0, 1); break;
		case ScreenAnchor_TM: rtv = game_screen_pct(0.5, 1); break;
		case ScreenAnchor_TR: rtv = game_screen_pct(1, 1); break;
	}
	return CGPointAdd(rtv, offset);
}

void callback_run(CallBack *c) {
	IMP imp = [c.target methodForSelector:c.selector];
	void (*func)(id, SEL) = (void *)imp;
	func(c.target,c.selector);
}

CallBack* callback_cons(NSObject *tar, SEL sel) {
    CallBack* cb = [[CallBack alloc] init];
    cb.target = tar;
	cb.selector = sel;
    return cb;
}

HitRect hitrect_cons_x1y1_x2y2(float x1, float y1, float x2, float y2) {
	struct HitRect n;
    n.x1 = x1;
    n.y1 = y1;
    n.x2 = x2;
    n.y2 = y2;
    return n;
}

HitRect hitrect_cons_xy_widhei(float x1, float y1, float wid, float hei) {
    return hitrect_cons_x1y1_x2y2(x1, y1, x1+wid, y1+hei);
}

CGRect hitrect_to_cgrect(HitRect rect) {
    return CGRectMake(rect.x1, rect.y1, rect.x2-rect.x1, rect.y2-rect.y1);
}

BOOL hitrect_touch(HitRect r1, HitRect r2) {
    return !(r1.x1 > r2.x2 ||
             r2.x1 > r1.x2 ||
             r1.y1 > r2.y2 ||
             r2.y1 > r1.y2);
}

CGFloat SEG_NO_VALUE() {
	return -99999.995;
}

CGPoint line_seg_intersection_pts(CGPoint a1, CGPoint a2, CGPoint b1, CGPoint b2) {
	CGPoint null_point = CGPointMake(SEG_NO_VALUE(),SEG_NO_VALUE());
    double Ax = a1.x; double Ay = a1.y;
	double Bx = a2.x; double By = a2.y;
	double Cx = b1.x; double Cy = b1.y;
	double Dx = b2.x; double Dy = b2.y;
	double X; double Y;
	double  distAB, theCos, theSin, newX, ABpos ;
	
	if ((Ax==Bx && Ay==By) || (Cx==Dx && Cy==Dy)) return null_point; //  Fail if either line segment is zero-length.
    
	Bx-=Ax; By-=Ay;//Translate the system so that point A is on the origin.
	Cx-=Ax; Cy-=Ay;
	Dx-=Ax; Dy-=Ay;
	
	distAB=sqrt(Bx*Bx+By*By);//Discover the length of segment A-B.
	
	theCos=Bx/distAB;//Rotate the system so that point B is on the positive X axis.
	theSin=By/distAB;
    
	newX=Cx*theCos+Cy*theSin;
	Cy  =Cy*theCos-Cx*theSin; Cx=newX;
	newX=Dx*theCos+Dy*theSin;
	Dy  =Dy*theCos-Dx*theSin; Dx=newX;
	
	if ((Cy<0. && Dy<0.) || (Cy>=0. && Dy>=0.)) return null_point;//C-D must be origin crossing line
	
	ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);//Discover the position of the intersection point along line A-B.
	
    
	if (ABpos<0. || ABpos-distAB> 0.001) {
        return null_point;//  Fail if segment C-D crosses line A-B outside of segment A-B.
	}
        
	X=Ax+ABpos*theCos;//Apply the discovered position to line A-B in the original coordinate system.
	Y=Ay+ABpos*theSin;
	
	return ccp(X,Y);
}

float shortest_angle(float src, float dest) {
	float shortest_angle=fmod((fmod((dest - src) , 360) + 540), 360) - 180;
	return shortest_angle;
}

float cubic_angular_interp(float src, float dest, float c1, float c2, float t) {
	t = cubic_interp(0, 1, c1, c2, t);
	return src + shortest_angle(src, dest) * t;
}

CGPoint line_seg_intersection(line_seg a, line_seg b) {
    return line_seg_intersection_pts(a.a, a.b, b.a, b.b);
}

line_seg line_seg_cons(CGPoint a, CGPoint b) {
    struct line_seg new;
    new.a = a;
    new.b = b;
    return new;
}

GLRenderObject* render_object_cons(CCTexture* tex, int npts) {
    GLRenderObject *n = [[GLRenderObject alloc] init];
    n.texture = tex;
    n.isalloc = 1;
    n.pts = npts;
    return n;
}

void render_object_draw(CCRenderer* renderer, CCRenderState *renderState, const GLKMatrix4 *transform, GLRenderObject *obj) {
	CCRenderBuffer buffer = [renderer enqueueTriangles:obj.pts/2 andVertexes:obj.pts withState:renderState globalSortOrder:0];
	for (int i = 0; i < obj.pts; i++) {
		CCVertex vert;
		vert.position = GLKVector4Make(obj.tri_pts[i].x, obj.tri_pts[i].y, 0, 1);
		vert.texCoord1 = GLKVector2Make(obj.tex_pts[i].x, obj.tex_pts[i].y);
		vert.color = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
		CCRenderBufferSetVertex(buffer, i, CCVertexApplyTransform(vert, transform));
	}
	CCRenderBufferSetTriangle(buffer, 0, 0, 1, 2);
	if (obj.pts == 4) CCRenderBufferSetTriangle(buffer, 1, 1, 2, 3);
}

void render_object_tex_map_to_tri_loc(GLRenderObject *o, int len) {
    for (int i = 0; i < len; i++) {
        o.tex_pts[i] = fccp(o.tri_pts[i].x/o.texture.pixelWidth, o.tri_pts[i].y/o.texture.pixelHeight);
    }
}

CGRect CGRectFromString_2(NSString *str) {
	str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
	NSArray* rtv = [str componentsSeparatedByString:@","];
	return CGRectMake([rtv[0] floatValue], [rtv[1] floatValue], [rtv[2] floatValue], [rtv[3] floatValue]);
}

CGRect rect_from_dict(NSDictionary* dict, NSString* tar) {
    NSDictionary *frames_dict = [dict objectForKey:@"frames"];
    NSDictionary *obj_info = [frames_dict objectForKey:tar];
    NSString *txt = [obj_info objectForKey:@"textureRect"];
	CGRect r = CGRectFromString_2(txt);
	return r;
}

void render_object_transform(GLRenderObject* o, CGPoint position) {
	o.tri_pts[0] = fccp(position.x+o.tri_pts[0].x-o.transform.x, position.y+o.tri_pts[0].y-o.transform.y);
	o.tri_pts[1] = fccp(position.x+o.tri_pts[1].x-o.transform.x, position.y+o.tri_pts[1].y-o.transform.y);
	o.tri_pts[2] = fccp(position.x+o.tri_pts[2].x-o.transform.x, position.y+o.tri_pts[2].y-o.transform.y);
	o.tri_pts[3] = fccp(position.x+o.tri_pts[3].x-o.transform.x, position.y+o.tri_pts[3].y-o.transform.y);
	o.transform = ccp2fccp(position);
}

CameraZoom camerazoom_cons(float x, float y, float z) {
    struct CameraZoom c = {x,y,z};
    return c;
}

CCAction* animaction_cons(NSArray *a, float speed, NSString *tex_key) {
	CCTexture *texture = [Resource get_tex:tex_key];
	NSMutableArray *animFrames = [NSMutableArray array];
	for (NSString* k in a) {
		CGRect rect = [FileCache get_cgrect_from_plist:tex_key idname:k];
		[animFrames addObject:[CCSpriteFrame frameWithTexture:texture rectInPixels:rect rotated:NO offset:CGPointZero originalSize:rect.size]];
		 //[CCSpriteFrame frameWithTexture:texture rectInPixels:[FileCache get_cgrect_from_plist:tex_key idname:k]]
	}
	
	CCAnimation *ccanim = [CCAnimation animationWithSpriteFrames:animFrames delay:speed];
	ccanim.restoreOriginalFrame = YES;
    return [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:ccanim]];
}

CCAction* animaction_nonrepeating_cons(NSArray *a, float speed, NSString *tex_key) {
	CCTexture *texture = [Resource get_tex:tex_key];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) {
		CGRect rect = [FileCache get_cgrect_from_plist:tex_key idname:k];
		[animFrames addObject:[CCSpriteFrame frameWithTexture:texture rectInPixels:rect rotated:NO offset:CGPointZero originalSize:rect.size]];
	}
	CCAnimation *ccanim = [CCAnimation animationWithSpriteFrames:animFrames delay:speed];
	ccanim.restoreOriginalFrame = NO;
	return [CCActionAnimate actionWithAnimation:ccanim];
}

NSString* platform() {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithUTF8String:machine];
	free(machine);
	return platform;
}

void scale_to_fit_screen_x(CCSprite *spr) {
	[spr setScaleX:game_screen().width/spr.textureRect.size.width];
}
void scale_to_fit_screen_y(CCSprite *spr) {
	[spr setScaleY:game_screen().height/spr.textureRect.size.height];
}

#define KEY_UUID @"key_uuid"
NSString* unique_id() {
	if ([DataStore get_str_for_key:KEY_UUID] == NULL) {
		CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
		NSString *uuid_str = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
		CFRelease((CFTypeRef)uuid);
		[DataStore set_key:KEY_UUID str_value:uuid_str];
	}
	return [DataStore get_str_for_key:KEY_UUID];
}

CCLabelTTF* label_cons(CGPoint pos, ccColor3B color, int fontSize, NSString* str) {
	CCLabelTTF *rtv = (CCLabelTTF*)[[CCLabelTTF labelWithString:str fontName:@"5ceta_mono.ttf" fontSize:fontSize] set_pos:pos];
	[rtv setColor:_CCColor(color)];
	return rtv;
}

float bezier_val_for_t(float p0, float p1, float p2, float p3, float t) {
	float cp0 = (1 - t)*(1 - t)*(1 - t);
	float cp1 = 3 * t * (1-t)*(1-t);
	float cp2 = 3 * t * t * (1 - t);
	float cp3 = t * t * t;
	return cp0 * p0 + cp1 * p1 + cp2 * p2 + cp3 * p3;
}

CGPoint bezier_point_for_t(CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3, float t) {
	return ccp(
		bezier_val_for_t(p0.x, p1.x, p2.x, p3.x, t),
		bezier_val_for_t(p0.y, p1.y, p2.y, p3.y, t)
	);
}

float cubic_interp(float a, float b, float c1, float c2, float t) {
	CGPoint bez = bezier_point_for_t(ccp(0,0), ccp(0.25,c1), ccp(0.75,c2), ccp(1,1), t);
	return bez.y * (b-a) + a;
}

float signum(float value) {
	return (value < 0) ? -1 : (value > 0) ? 1 : 0;
}

float low_filter(float value, float min) {
	return ABS(value) < ABS(min) ? 0 : value;
}

Vec3D vec_from_ccrotation(float rotation) {
	return vec_cons(cosf(deg_to_rad(-rotation)), sinf(deg_to_rad(-rotation)), 0);
}

CCSprite* flipper_cons_for(CCSprite* obj, float scx, float scy) {
	CCSprite *flipper = [CCSprite node];
	[flipper setScaleX:scx];
	[flipper setScaleY:scy];
	[flipper addChild:obj];
	return flipper;
}

float running_avg(float avg, float val, float ct) {
	avg -= avg / ct;
	avg += val / ct;
	return avg;
}

CGPoint point_box_intersection(CGSize box_size, Vec3D dir_vec) {
	vec_scale_m(&dir_vec, box_size.height * box_size.width);
	CGPoint center = ccp(box_size.width/2,box_size.height/2);
	if (ABS(dir_vec.y) > ABS(dir_vec.x)) {
		if (dir_vec.y > 0) {
			return line_seg_intersection_pts(center, CGPointAdd(center, ccp(dir_vec.x,dir_vec.y)), ccp(0,box_size.height), ccp(box_size.width,box_size.height));
		} else {
			return line_seg_intersection_pts(center, CGPointAdd(center, ccp(dir_vec.x,dir_vec.y)), ccp(0,0), ccp(box_size.width,0));
		}
	} else {
		if (dir_vec.x > 0) {
			return line_seg_intersection_pts(center, CGPointAdd(center, ccp(dir_vec.x,dir_vec.y)), ccp(box_size.width,0), ccp(box_size.width,box_size.height));
		} else {
			return line_seg_intersection_pts(center, CGPointAdd(center, ccp(dir_vec.x,dir_vec.y)), ccp(0,0), ccp(0,box_size.height));
		}
	}
}