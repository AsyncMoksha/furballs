//
//  CCMenuOverload.m
//  PAWS
//
//  Created by Zinan Xing on 10/28/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "CCMenuCategory.h"

@implementation CCMenu (ccTouchMoved)

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *currentItem = [self itemForTouch:touch];
	
	if (currentItem != selectedItem_) {
		[selectedItem_ unselected];
		selectedItem_ = currentItem;
		[selectedItem_ selected];
	} else {    //Modified by Melo for Option Scene Slides Control 10/23/11
		if ([selectedItem_ respondsToSelector: @selector(dragToPoint:)]) {
			CGPoint touchLocation = [selectedItem_ convertTouchToNodeSpace: touch];
			[selectedItem_ dragToPoint: touchLocation];
		}
	}
}

@end
