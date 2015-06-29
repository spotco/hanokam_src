#import "SpriterData.h"
#import "SpriterXMLParser.h"
#import "SpriterTypes.h"
#import "Common.h"

@implementation SpriterData {
	NSMutableDictionary *_folders;
	NSMutableDictionary *_animations;
	NSMutableDictionary *_atlas;
}

-(NSDictionary*)folders { return _folders; }
-(NSDictionary*)animations { return _animations; }

-(TGSpriterAnimation*)anim_of_name:(NSString*)name { return [_animations objectForKey:name]; }
-(TGSpriterFile*)file_for_folderid:(int)folderid fileid:(int)fileid {
	TGSpriterFolder *folder = _folders[[NSNumber numberWithInt:folderid]];
	return [folder._files objectForKey:[NSNumber numberWithInt:fileid]];
}

+(SpriterData*)cons_data_from_spritesheetreaders:(NSArray*)sheetreaders scml:(NSString*)scml {
	return [[SpriterData alloc] cons_data_from_spritesheetreaders:sheetreaders scml:scml];
}

-(SpriterData*)cons_data_from_spritesheetreaders:(NSArray*)sheetreaders scml:(NSString*)scml {
	TGSpriterConfigNode *root = [[[SpriterXMLParser alloc] init] parseSCML:scml];
	
	_folders = [NSMutableDictionary dictionary];
	_animations = [NSMutableDictionary dictionary];
	_atlas = [NSMutableDictionary dictionary];
	
    for (TGSpriterConfigNode *itr_base in [[root.children objectAtIndex:0] children]) {
		if ([[itr_base name] isEqualToString:@"atlas"]) {
			[self handle_atlas:itr_base sheetreaders:sheetreaders];
			
		} else if ([[itr_base name] isEqualToString:@"folder"]) {
			[self handle_folder:itr_base];
			
        } else if ([[itr_base name] isEqualToString:@"entity"]) {
            for (TGSpriterConfigNode *itr_entity_child in itr_base.children) {
				if ([[itr_entity_child name] isEqualToString:@"animation"]) {
					[self handle_animation:itr_entity_child];
					
				}
            }
		}
    }
	
	return self;
}

-(void)replace_atlas_index:(int)index with:(id<SpriteSheetReader>)tar {
	_atlas[@(index)] = tar;
	for (NSNumber *folder_id in _folders.keySet) {
		TGSpriterFolder *itr_folder = _folders[folder_id];
		if (itr_folder._atlas == index) {
			for (NSNumber *file_id in itr_folder._files.keySet) {
				TGSpriterFile *itr_file = itr_folder._files[file_id];
				itr_file._texture = [tar texture];
				itr_file._rect = [tar cgRectForFrame:itr_file._name];
				
			}
		}
	}
}

-(void)handle_atlas:(TGSpriterConfigNode*)itr_base sheetreaders:(NSArray*)sheetreaders {
	for (int i = 0; i < itr_base.children.count; i++) {
		TGSpriterConfigNode *itr_atlas_element = [itr_base.children objectAtIndex:i];
		NSString *itr_atlas_element_name = itr_atlas_element.properties[@"name"];
		for (id<SpriteSheetReader> itr_sheetreaders in sheetreaders) {
			if ([[itr_sheetreaders filepath] isEqualToString:itr_atlas_element_name]) {
				_atlas[@(i)] = itr_sheetreaders;
				break;
			}
		}
	}
}



-(void)handle_folder:(TGSpriterConfigNode*)itr_base {
	TGSpriterFolder *neu_folder = [[TGSpriterFolder alloc] init];
	neu_folder._id = [itr_base getId];
	neu_folder._atlas = [itr_base.properties[@"atlas"] intValue];
	
	id<SpriteSheetReader> atlas_element = _atlas[@(neu_folder._atlas)];
	
	for (TGSpriterConfigNode *itr_files in itr_base.children) {
		TGSpriterFile *neu_file = [[TGSpriterFile alloc] init];
		neu_file._id = [itr_files getId];
		neu_file._name = itr_files.properties[@"name"];
		neu_file._pivot = ccp([itr_files getVal:@"pivot_x"],[itr_files getVal:@"pivot_y"]);
		neu_file._rect = [atlas_element cgRectForFrame:itr_files.properties[@"name"]];
		neu_file._texture = atlas_element.texture;
		
		neu_folder._files[[NSNumber numberWithInt:neu_file._id]] = neu_file;
	}
	
	_folders[[NSNumber numberWithInt:neu_folder._id]] = neu_folder;
}

-(void)handle_animation:(TGSpriterConfigNode*)itr_entity_child {
	TGSpriterAnimation * spriterAnimation = [[TGSpriterAnimation alloc] init];
	spriterAnimation._name = [itr_entity_child.properties objectForKey:@"name"];
	spriterAnimation._duration = [[itr_entity_child.properties objectForKey:@"length"] intValue];

	for (TGSpriterConfigNode *itr_animation_child in itr_entity_child.children) {
		if ([[itr_animation_child name] isEqualToString:@"mainline"]) {
			for (TGSpriterConfigNode *itr_key in itr_animation_child.children) {
				[self handle_mainline_key:spriterAnimation itr:itr_key];
			}
			
		} else if ([[itr_animation_child name] isEqualToString:@"timeline"]) {
			[self handle_timeline:spriterAnimation itr:itr_animation_child];
		}
	}
	_animations[spriterAnimation._name] = spriterAnimation;
}

-(void)handle_mainline_key:(TGSpriterAnimation*)spriterAnimation itr:(TGSpriterConfigNode*)itr_key {
	TGSpriterMainlineKey *mainlineKey = [[TGSpriterMainlineKey alloc] init];
	
	NSMutableString *hash = [NSMutableString stringWithString:@"-"];
	
	for (TGSpriterConfigNode *itr_key_child in itr_key.children) {
		TGSpriterObjectRef *objectRef = [[TGSpriterObjectRef alloc] init];
		objectRef._id = [[itr_key_child.properties objectForKey:@"id"] intValue];
		objectRef._timeline_id = [[itr_key_child.properties objectForKey:@"timeline"] intValue];
		if ([itr_key_child.properties objectForKey:@"parent"] == NULL) {
			objectRef._is_root = YES;
		} else {
			objectRef._parent_bone_id = [[itr_key_child.properties objectForKey:@"parent"] intValue];
		}
		
		if ([[itr_key_child name] isEqualToString:@"bone_ref"]) {
			[mainlineKey._bone_refs addObject:objectRef];
			[hash appendString:strf("(b_%d-%d)",objectRef._id,objectRef._parent_bone_id)];
			
		} else if ([[itr_key_child name] isEqualToString:@"object_ref"]) {
			objectRef._zindex = [[itr_key_child.properties objectForKey:@"id"] intValue];
			[mainlineKey._object_refs addObject:objectRef];
			[hash appendString:strf("(o_%d)",objectRef._parent_bone_id)];
		}
		
	}
	mainlineKey._hash = [[NSString stringWithString:hash] md5];
	//mainlineKey._hashtest = [NSString stringWithString:hash];
	mainlineKey._start_time = [[itr_key.properties objectForKey:@"time"] intValue];
	[spriterAnimation._mainline_keys addObject:mainlineKey];
}

-(void)handle_timeline:(TGSpriterAnimation*)spriterAnimation itr:(TGSpriterConfigNode*)itr_animation_child {
	TGSpriterTimeline * timeline = [TGSpriterTimeline spriterTimeline];
	timeline._id = [[itr_animation_child.properties objectForKey:@"id"] intValue];
	timeline._name = [itr_animation_child.properties objectForKey:@"name"];
	
	for (TGSpriterConfigNode * key in itr_animation_child.children) {
		for (TGSpriterConfigNode * object in key.children) {
		
			TGSpriterTimelineKey * timelineKey = [TGSpriterTimelineKey spriterTimelineKey];
			timelineKey.folder = [[object.properties objectForKey:@"folder"] intValue];
			timelineKey.file = [[object.properties objectForKey:@"file"] intValue];
			timelineKey.position = ccp([[object.properties objectForKey:@"x"] doubleValue], [[object.properties objectForKey:@"y"] doubleValue]);
			
			if ([object.properties objectForKey:@"pivot_x"]) {
				timelineKey.anchorPoint = ccp([[object.properties objectForKey:@"pivot_x"] doubleValue],
											  [[object.properties objectForKey:@"pivot_y"] doubleValue]);
			} else {
				timelineKey.anchorPoint = ccp(0,1);
			}
			
			if ([object.properties objectForKey:@"scale_x"]) {
				timelineKey.scaleX = [[object.properties objectForKey:@"scale_x"] doubleValue];
			} else {
				timelineKey.scaleX = 1.0;
			}
			if ([object.properties objectForKey:@"scale_y"]) {
				timelineKey.scaleY = [[object.properties objectForKey:@"scale_y"] doubleValue];
			} else {
				timelineKey.scaleY = 1.0;
			}
			
			timelineKey.startsAt = [[key.properties objectForKey:@"time"] intValue];
			timelineKey.rotation = -[[object.properties objectForKey:@"angle"] doubleValue];
			
			if ([key.properties objectForKey:@"spin"]) {
				timelineKey.spin = [[key.properties objectForKey:@"spin"] intValue];
			} else {
				timelineKey.spin = 1;
			}
			
			if ([object.properties objectForKey:@"a"]) {
				timelineKey.alpha = [[object.properties objectForKey:@"a"] doubleValue];
			} else {
				timelineKey.alpha = 1;
			}
			
			[timeline addKeyFrame:timelineKey];
		}
	}
	
	
	spriterAnimation._timelines[[NSNumber numberWithInt:timeline._id]] = timeline;
}

@end
