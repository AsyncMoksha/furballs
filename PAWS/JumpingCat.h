//
//  JumpingCat.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/26/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

#define kJumpDistance 200
#define kJumpHeight 50

@interface JumpingCat : Unit  {
    int jumpCooldown;
    float groundPosition;
}

-(JumpingCat*) initWithUnit: (Unit *) unit;

-(CGRect)adjustedJumpBoundingBox;

-(void) doJumpAction;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

- (void) updateCoolDown;
@property (nonatomic, assign) int jumpCoolDown;
@property (nonatomic, assign) float groundPosition;

@end
