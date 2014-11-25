//
//  Catapult.m
//  PAWS
//
//  Created by Zinan Xing on 11/24/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Catapult.h"

@implementation Catapult 

@synthesize destination;

-(void) doCatapult{
    destination = self.position;
    self.position = ccp(-100.0, self.position.y);
    CCAction *jumpAction = [CCJumpTo actionWithDuration:1 position:destination height:100.0 jumps:1];
    [self runAction:jumpAction];
}
-(void) applyEffectOnUnits:(NSMutableArray *)unitArray {
    //CCLOG(@"test!!!!!!");
    for (Unit *unit in unitArray) {
        unit.hitPoint = 0.0f;
        [unit setState:DEAD];
    }
    [self setGameObjectState:REMOVED];
}

@end
