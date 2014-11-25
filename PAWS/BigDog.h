//
//  BigDog.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/4/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

@interface BigDog : Unit {
    NSMutableArray *unitStack;
}

-(BigDog*) initWithUnit: (Unit *) unit;
-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

@property (nonatomic, retain) NSMutableArray *unitStack;
@end
