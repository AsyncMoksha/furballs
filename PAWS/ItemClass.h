//
//  ItemClass.h
//  PAWS
//
//  Created by Zinan Xing on 11/3/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "GameObject.h"
#import "Unit.h"

/* Abandoned
 
// Item Type
#define ITEM_TYPE_OUR_UNITS           0
#define ITEM_TYPE_ENEMY_UNITS         1
#define ITEM_TYPE_AREA_EFFECT         2
#define ITEM_TYPE_INDIVIDULE_EFFECT   3

// Item ID
#define ITEM_THROW           0
#define ITEM_SHIELD          1
#define ITEM_MEDICATION      2
#define ITEM_STEROID         3
#define ITEM_WIND            4
#define ITEM_POISON          5
#define ITEM_SLEEP_POTION    6
#define ITEM_TRAP            7
#define ITEM_FLASH           8
#define ITEM_BOULDER         9
 */

//Item ID:
#define ITEM_PIGGYBANK  1
#define ITEM_PIGGYBANK_DOG  8
#define ITEM_CATAPULT   2
#define ITEM_FAN        3

@interface ItemClass : GameObject {
    NSInteger itemID;
    NSString *itemName;
    NSString *itemDescription;
    NSString *itemFrameName;
    NSInteger effectDuration;
    NSInteger effectRadius;
    NSInteger itemCost;
    NSInteger coolDown;
    float coolDownTimer;
    NSDictionary *statsModifiers;
    
    NSInteger timeLeft;
    
    float hitPointModifier;
    float attackModifier;
    float attackSpeedModifier;
    float speedModifier;
    float spawnRateModifier;
    
    NSMutableArray *itemListArray;
}

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *itemDescription;
@property (nonatomic, retain) NSString *itemFrameName;
@property (nonatomic, assign) NSInteger effectDuration;
@property (nonatomic, assign) NSInteger effectRadius;
@property (nonatomic, assign) NSInteger itemCost;
@property (nonatomic, assign) NSInteger coolDown;
@property (nonatomic, assign) float coolDownTimer;
@property (nonatomic, retain) NSDictionary *statsModifiers;

@property (nonatomic, assign) NSInteger timeLeft;

@property (nonatomic, assign) float hitPointModifier;
@property (nonatomic, assign) float attackModifier;
@property (nonatomic, assign) float attackSpeedModifier;
@property (nonatomic, assign) float speedModifier;
@property (nonatomic, assign) float spawnRateModifier;

@property (nonatomic, retain) NSMutableArray *itemListArray;

-(id) initWithItemID: (NSInteger) itemID;
-(void) applyEffectOnUnits: (NSMutableArray *) unitArray;
-(void) removeEffectOnUnits: (NSMutableArray *) unitArray;
-(void) applyPiggyBankEffect;
-(void) removePiggyBankEffect;
-(void) update;
/*
-(void) applyFanEffectWithLaneID : (int) lane
             andLevelID: (int) levelID;
 */

@end
