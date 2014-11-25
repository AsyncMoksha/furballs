//
//  GhostCat.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/23/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "Unit.h"

@interface GhostCat : Unit {
}

-(GhostCat*) initWithUnit: (Unit *) unit;
-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfAllyUnits:(NSMutableArray *)listOfAllyUnits andListOfEnemyUnits:(NSMutableArray *)listOfEnemyUnits;

@end
