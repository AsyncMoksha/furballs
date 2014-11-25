//
//  CCMenuOverload.h
//  PAWS
//
//  Created by Zinan Xing on 10/28/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "CCMenu.h"
#import "MenuItemSlider.h"

@interface CCMenu (ccTouchMoved)    //using category feature of Obj-C to override method ccTouchMoved
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
@end
