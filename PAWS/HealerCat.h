//
//  HealerCat.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/31/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

#define kHealPower 5

@interface HealerCat : Unit {
    int healCooldown;
    float healPower;
}

-(HealerCat*) initWithUnit: (Unit *) unit;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
              andListOfAllyUnits:(NSMutableArray *)listOfAllyUnits 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

- (void) updateCoolDown;

@property (nonatomic, assign) int healCoolDown;
@property (nonatomic, assign) float healPower;
@end
