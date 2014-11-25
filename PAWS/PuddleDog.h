//
//  PuddleDog.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/6/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

#import "BigDog.h"
#import "GhostDog.h"
//Dog
#define kNormalDog 10
#define kFastDog 11
#define kBigDog 12
#define kGhostDog 13
#define kStupidDog 14
#define kPuddle 15
#define kSiberianHusky 16

@interface PuddleDog : Unit {
    int summonCooldown;
}

-(PuddleDog*) initWithUnit: (Unit *) unit;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

- (void) updateCoolDown;

@property (nonatomic, assign) int summonCooldown;
@end
