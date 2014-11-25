//
//  ThrowingCat.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/18/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

@interface ThrowingCat : Unit {
    BOOL isInRange;
}

-(ThrowingCat*) initWithUnit: (Unit *) unit;

-(CGRect)adjustedThrowBoundingBox;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

@property (nonatomic, assign) BOOL isInRange;

@end
