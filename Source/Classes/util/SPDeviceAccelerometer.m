//
//  SPDeviceAccelerometer.m
//  hanokam
//
//  Created by spotco on 26/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SPDeviceAccelerometer.h"
#import "Common.h"

#if __CC_PLATFORM_ANDROID
	#import "hanokamActivity.h" 
	#import <AndroidKit/AndroidSensorManager.h>
	#import <AndroidKit/AndroidSensor.h>
	#import <AndroidKit/AndroidSensorEventListener.h>
	#import <AndroidKit/AndroidSensorEvent.h>
	#import <JavaFoundation/JavaFloatArray.h>
#else
	#import <CoreMotion/CoreMotion.h>
#endif


@implementation SPDeviceAccelerometer

#if __CC_PLATFORM_ANDROID
	static AndroidSensorEventListener *_listener;
	static float _frame_x;
	static float _last_x;
#else
	static CMMotionManager *_motion_manager;
#endif

+(void)start {
#if __CC_PLATFORM_ANDROID
	AndroidContext *context = [hanokamActivity getActivity];
	AndroidSensorManager *sensor_manager = (AndroidSensorManager*)[context systemServiceForName:AndroidContextSensorService];
	AndroidSensor *sensor = [sensor_manager defaultSensorForType:AndroidSensorTypeAccelerometer];
	_listener = [AndroidSensorEventListener listener];
	_listener.onSensorChangedHandler = ^(AndroidSensorEvent* event) {
		JavaFloatArray *vals = event.values;
		float x = -[vals valueAtIndex:0] * 0.1;
		if (ABS(_last_x-x)<0.1) {
			x = _last_x;
		}
		_last_x = x;
		_frame_x = x;
	};
	[sensor_manager registerListener:_listener sensor:sensor rate:AndroidSensorManagerSensorDelayGame];
#else
	_motion_manager = [[CMMotionManager alloc] init];
	_motion_manager.accelerometerUpdateInterval = 1.0/60.0;
	[_motion_manager startAccelerometerUpdates];
#endif
}

+(float)accel_x {
#if __CC_PLATFORM_ANDROID
	return _frame_x;
#else
	if (!_motion_manager.accelerometerActive) [_motion_manager startAccelerometerUpdates];
	return _motion_manager.accelerometerData.acceleration.x;
#endif
}

@end
