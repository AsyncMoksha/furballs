//
//  ConsoleLayer.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/11/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "Unit.h"
#import "BattleHUD.h"

@interface ConsoleLayer : CCLayerColor {
    CCLabelTTF *unitNameLabel;
    CCLabelTTF *hitPointLabel;
    CCLabelTTF *attackLabel;
    CCLabelTTF *attackSpeedLabel;
    CCLabelTTF *speedLabel;
    CCLabelTTF *spawnRateLabel;
    
    CCLabelTTF *dogUnitNameLabel;
    CCLabelTTF *dogHitPointLabel;
    CCLabelTTF *dogAttackLabel;
    CCLabelTTF *dogAttackSpeedLabel;
    CCLabelTTF *dogSpeedLabel;
    CCLabelTTF *dogSpawnRateLabel;
    
    int unitIndex;
    int catIndex;
    int dogIndex;
    NSMutableArray *unitArray;
    NSMutableArray *catArray;
    NSMutableArray *dogArray;
}

-(void) openConsoleWithArray: (NSMutableArray *)array;
-(void) openConsoleWithArrays: (NSMutableArray *)catUnits
              andWithDogArray: (NSMutableArray *)dogUnits;

@property (nonatomic, retain) CCLabelTTF *unitNameLabel;
@property (nonatomic, retain) CCLabelTTF *hitPointLabel;
@property (nonatomic, retain) CCLabelTTF *attackLabel;
@property (nonatomic, retain) CCLabelTTF *attackSpeedLabel;
@property (nonatomic, retain) CCLabelTTF *speedLabel;
@property (nonatomic, retain) CCLabelTTF *spawnRateLabel;
@property (nonatomic, retain) CCLabelTTF *dogUnitNameLabel;
@property (nonatomic, retain) CCLabelTTF *dogHitPointLabel;
@property (nonatomic, retain) CCLabelTTF *dogAttackLabel;
@property (nonatomic, retain) CCLabelTTF *dogAttackSpeedLabel;
@property (nonatomic, retain) CCLabelTTF *dogSpeedLabel;
@property (nonatomic, retain) CCLabelTTF *dogSpawnRateLabel;
@property (nonatomic, assign) int unitIndex;
@property (nonatomic, assign) int catIndex;
@property (nonatomic, assign) int dogIndex;
@property (nonatomic, assign) NSMutableArray *unitArray;
@property (nonatomic, assign) NSMutableArray *catArray;
@property (nonatomic, assign) NSMutableArray *dogArray;

@end
