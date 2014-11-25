//
//  Coin.h
//  PAWS
//
//  Created by Zinan Xing on 10/16/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "GameObject.h"
#import "Unit.h"

#define kCoinObject 30
#define kCoinAmount 10


@interface Coin : GameObject {
    NSInteger amount;
}

-(Coin*) initWithDictionary:(NSDictionary*)dictionary;

-(Coin*) initWithRandomPositionWithTime: (int) interval;

-(CGRect)adjustedBoundingBox;

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
             andListOfPlayerUnits:(NSMutableArray*)listOfPlayerUnits
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits;

-(void) doCollectAction;

@property (nonatomic, assign) NSInteger amount;

@end
