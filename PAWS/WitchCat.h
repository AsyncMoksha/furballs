//
//  WitchCat.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/3/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

#define kFearAuraPower 0.5
#define kFearAuraRadius 100

@interface WitchCat : Unit {
    float fearAuraPower;
}

-(WitchCat*) initWithUnit: (Unit *) unit;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

@property (nonatomic, assign) float fearAuraPower;
@end
