//
//  SiberianHuskyDog.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/7/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

#define kGrowlAuraPower 0.25
#define kGrowlAuraRadius 200

@interface SiberianHuskyDog : Unit {
    float growlAuraPower;
}

-(SiberianHuskyDog*) initWithUnit: (Unit *) unit;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
              andListOfAllyUnits:(NSMutableArray *)listOfAllyUnits 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

@property (nonatomic, assign) float growlAuraPower;

@end
