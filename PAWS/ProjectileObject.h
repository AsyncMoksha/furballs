//
//  ProjectileObject.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 11/18/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "GameObject.h"
#import "Unit.h"

#define kProjectileSpeed 100

@interface ProjectileObject : GameObject {
    float damage;
    BOOL isInRange;
    CCSprite *shadowSprite;
}

-(ProjectileObject*) initWithUnit: (Unit*) unit;

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits;

-(CGRect)adjustedBoundingBox;

-(void) doMoveAction;

@property (nonatomic, assign) float damage;
@property (nonatomic, assign) BOOL isInRange;
@property (nonatomic, retain) CCSprite *shadowSprite;

@end
