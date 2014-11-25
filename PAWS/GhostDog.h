//
//  GhostDog.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/5/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

@interface GhostDog : Unit


-(GhostDog*) initWithUnit: (Unit *) unit;
-(CGRect) adjustedBoundingBox;
-(void) updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;
@end
