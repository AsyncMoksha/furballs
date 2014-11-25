//
//  GameObject.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/3/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

typedef enum { DROPPED, COLLECTED, REMOVED } GAME_OBJ_STATE;

@interface GameObject : CCSprite
{
    NSNumber *dropPosition;
    NSNumber *path;
    NSNumber *time;
    NSNumber *type;
    
    GAME_OBJ_STATE gameObjectState;
}

-(GameObject*) initWithDictionary:(NSDictionary*)dictionary;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
           andListOfPlayerUnits:(NSMutableArray*)listOfPlayerUnits
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits;
-(CGRect)adjustedBoundingBox;
 
@property (nonatomic, retain) NSNumber *dropPosition;
@property (nonatomic, retain) NSNumber *path;
@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSNumber *type;

@property (nonatomic, assign) GAME_OBJ_STATE gameObjectState;

@end
