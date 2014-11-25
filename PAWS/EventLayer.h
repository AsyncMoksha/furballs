//
//  EventLayer.h
//  PAWS
//
//  AbstractClass for any type of event
//
//  Created by Pisit Praiwattana on 10/26/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum {EVENT_ICON_TAG} EVENT_TAG;

@interface EventLayer : CCLayer {
    CCSprite *_eventIcon;
    BOOL _isEventShowed;
}
-(void)popIconInCenterWithFile:(NSString*)filename withScale:(float)iconScale andSecond:(float)second;
-(void)popIconInFromLeftWithFile:(NSString*)filename withScale:(float)iconScale andSecond:(float)second;
-(void)removeEventIconAfterWaitFor:(float)second;
-(void)removeEventIcon;
@property (nonatomic,retain) CCSprite *eventIcon;
@property (nonatomic,assign) BOOL isEventShowed;
@end
