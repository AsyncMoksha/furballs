//
//  EventLayer.m
//  PAWS
//
//  Created by Pisit Praiwattana on 10/26/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "EventLayer.h"


@implementation EventLayer
@synthesize eventIcon = _eventIcon;
@synthesize isEventShowed = _isEventShowed;

-(id)init{
    if(self = [super init]){
        
        _isEventShowed = false;
        self.isTouchEnabled = true;
    }
    return self;
}
-(void)popIconInCenterWithFile:(NSString*)filename withScale:(float)iconScale andSecond:(float)second{
    if(!_isEventShowed){
        CCLOG(@"popping icon out in center with %@ with scale of %f for %f seconds",filename,iconScale,second);
        CGSize size = [[CCDirector sharedDirector] winSize];
        _eventIcon = [CCSprite spriteWithFile:filename];
        [_eventIcon setAnchorPoint:ccp(0.5,0.5)];
        [_eventIcon setPosition:ccp(size.width/2, size.height/2)];
        [_eventIcon setScale: iconScale];
        [_eventIcon setVisible:false];
    
        [self removeChildByTag:EVENT_ICON_TAG cleanup:true];
        [self addChild:_eventIcon z:1 tag:EVENT_ICON_TAG];
    
    
        id scaleAction = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
        id easeAction = [CCEaseIn actionWithAction:scaleAction rate:2];
        [_eventIcon runAction:easeAction];
        [_eventIcon setVisible:true];
    
        [self removeEventIconAfterWaitFor:second];
        _isEventShowed = true;
    }
}
-(void)popIconInFromLeftWithFile:(NSString *)filename withScale:(float)iconScale andSecond:(float)second{
    if(!_isEventShowed){
        CCLOG(@"popping icon from the left with %@ with scale of %f for %f seconds",filename,iconScale,second);
        CGSize size = [[CCDirector sharedDirector] winSize];
        _eventIcon = [CCSprite spriteWithFile:filename];
        [_eventIcon setAnchorPoint:ccp(0,0.5)];
        [_eventIcon setPosition:ccp(0 - _eventIcon.contentSize.width, size.height/2)];
        [_eventIcon setScale: iconScale];
        [_eventIcon setVisible:false];
    
        [self removeChildByTag:EVENT_ICON_TAG cleanup:true];
        [self addChild:_eventIcon z:1 tag:EVENT_ICON_TAG];
    
        id moveFromLeft = [CCMoveTo actionWithDuration:0.5f position:ccp(0,_eventIcon.position.y)];
        id easeAction = [CCEaseIn actionWithAction:moveFromLeft rate:2];
        [_eventIcon runAction:easeAction];
        [_eventIcon setVisible:true];
    
    
        [self removeEventIconAfterWaitFor:second];
        _isEventShowed = true;
    }
}

-(void)removeEventIconAfterWaitFor:(float)second{
    CCLOG(@"Wait for %f second then remove event",second);
    id waitForSecond = [CCDelayTime actionWithDuration:second];
    [self runAction:[CCSequence actions:waitForSecond,
                     [CCCallFunc actionWithTarget:self selector:@selector(removeEventIcon)], nil]];
}
-(void)removeEventIcon{
    [self removeChildByTag:EVENT_ICON_TAG cleanup:YES];
    _isEventShowed = false;
}

-(void) registerWithTouchDispatcher
{
    //Override to register this CCLayer to globalTouch Dispatcher
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

/**
 *  ccTouchBegan
 *  Keep track of touch at starting point.
 */
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    //Return true to claim this touch
    return TRUE;    
}
/**
 *  ccTouchEnded
 *  After player release his/her finger read next message
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(_isEventShowed){
        [self removeEventIcon];
    }
}

-(void)dealloc{
    [_eventIcon release];
    _eventIcon = nil;
    [super dealloc];
}
@end
