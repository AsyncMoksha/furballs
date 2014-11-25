//
//  ItemClass.m
//  PAWS
//
//  Created by Zinan Xing on 11/3/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "ItemClass.h"

@implementation ItemClass

@synthesize itemID;
@synthesize itemName;
@synthesize itemDescription;
@synthesize itemFrameName;
@synthesize effectDuration;
@synthesize effectRadius;
@synthesize itemCost;
@synthesize coolDown;
@synthesize coolDownTimer;
@synthesize statsModifiers;

@synthesize timeLeft;

@synthesize hitPointModifier;
@synthesize attackModifier;
@synthesize attackSpeedModifier;
@synthesize speedModifier;
@synthesize spawnRateModifier;

@synthesize itemListArray;

-(void) dealloc {
    [itemName release];
    itemName = nil;
    [itemDescription release];
    itemDescription = nil;
    [itemFrameName release];
    itemFrameName = nil;
    [statsModifiers release];
    statsModifiers = nil;
    
    [itemListArray release];
    itemListArray = nil;
    
}

-(id) initWithItemID: (NSInteger) _itemID{
    
    self = [super init];
    if (self) {
        //Read unit levels file from application bundle
        NSString* itemPath = [[NSBundle mainBundle] pathForResource:@"simpleItems" ofType:@"plist"];
        NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: itemPath];    
        
        itemListArray = [[NSMutableArray alloc] initWithArray:[itemDictionary objectForKey:@"item"]];
        
        int idToUse = 0;
        for (int i=0; i<4; i++) {
            //CCLOG(@"ID to compare is %d", _itemID);
            //CCLOG(@"item id is %d", [[[itemListArray objectAtIndex:i] objectForKey:@"id"] intValue]);
            if([[[itemListArray objectAtIndex:i] objectForKey:@"id"] intValue] == _itemID){
                
                idToUse = i;
                break;
            }
        }
        itemID = _itemID;
        //itemID = [[[itemListArray objectAtIndex:_itemID] objectForKey:@"id"] integerValue]; 
        itemName = [[itemListArray objectAtIndex:idToUse] objectForKey:@"name"];
        itemDescription = [[itemListArray objectAtIndex:idToUse] objectForKey:@"description"];
        itemFrameName = [[itemListArray objectAtIndex:idToUse] objectForKey:@"frameName"];
        effectDuration = [[[itemListArray objectAtIndex:idToUse] objectForKey:@"duration"] integerValue];
        effectRadius = [[[itemListArray objectAtIndex:idToUse] objectForKey:@"name"] integerValue];
        itemCost = [[[itemListArray objectAtIndex:idToUse] objectForKey:@"cost"] integerValue];
        coolDown = [[[itemListArray objectAtIndex:idToUse] objectForKey:@"coolDown"] integerValue];
        coolDownTimer = 0;
        statsModifiers = [[itemListArray objectAtIndex:idToUse] objectForKey:@"modifiers"];
        
        
        // Load modifiers from statsModifiers
        hitPointModifier = [[statsModifiers objectForKey:@"hitPoint"] floatValue];    
        attackModifier = [[statsModifiers objectForKey:@"attack"] floatValue];
        attackSpeedModifier = [[statsModifiers objectForKey:@"attackSpeed"] floatValue];
        speedModifier = [[statsModifiers objectForKey:@"speed"] floatValue];
        spawnRateModifier = [[statsModifiers objectForKey:@"spawnRate"] floatValue];
        
        // Initialize time left
        timeLeft = effectDuration;
    }
    
    
    return self;
}

-(void) applyEffectOnUnits: (NSMutableArray *) unitArray {

    for (Unit* unit in unitArray) {
        // Get current stats
        float currentHitPoint = [unit hitPoint];
        float currentAttack = [unit attack];
        float currentAttackSpeed = [unit attackSpeed];
        float currentSpeed = [unit speed];
        float currentSpawnRate = [unit spawnRate];
        
        // Apply effects on to every units in array
        if( itemID != ITEM_PIGGYBANK ) {    //If it's not a piggy bank
            CCLOG(@"Item effect applied");
            [unit setHitPoint: currentHitPoint * (hitPointModifier + 1.0f)];
            [unit setAttack: currentAttack * (attackModifier + 1.0f)];
            [unit setAttackSpeed: currentAttackSpeed * (attackSpeedModifier + 1)];
            [unit setSpeed: currentSpeed * (speedModifier + 1.0f)];
            [unit setSpawnRate: currentSpawnRate * (spawnRateModifier + 1.0)];
        }
        CCLOG(@"Unit speed: %.02f", unit.speed );
        
    }    
}

-(void) removeEffectOnUnits:(NSMutableArray *)unitArray {
    
    for (Unit* unit in unitArray) {
        // Get current stats
        float currentHitPoint = [unit hitPoint];
        float currentAttack = [unit attack];
        float currentAttackSpeed = [unit attackSpeed];
        float currentSpeed = [unit speed];
        float currentSpawnRate = [unit spawnRate];
        
        // Remove effect
        if( itemID != ITEM_PIGGYBANK ) {    //If it's not a piggy bank
            CCLOG(@"Item Effect Removed");
            [unit setHitPoint: currentHitPoint / (hitPointModifier + 1)];
            [unit setAttack: currentAttack / (attackModifier + 1)];
            [unit setAttackSpeed: currentAttackSpeed / (attackSpeedModifier + 1)];
            [unit setSpeed: currentSpeed / (speedModifier + 1)];
            [unit setSpawnRate: currentSpawnRate / (spawnRateModifier + 1)];
        } 
    }  
}

-(void) applyPiggyBankEffect {
    
}

-(void) removePiggyBankEffect {

}

-(void) update {
    if(timeLeft > 0)
        timeLeft --;

}

/*
-(void) applyFanEffectWithLaneID : (int) lane
                       andLevelID: (int) levelID{
    
    NSString *levelFileName = [NSString string];
    if(levelID < 0)
        levelFileName = @"level1";
    else if ( levelID == 2) {
        levelFileName = @"levelCat1";
    }
    else
        levelFileName = [NSString stringWithFormat:@"level%d", levelID]; 
    
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:levelFileName ofType:@"plist"];
    NSDictionary *levelContent = [NSMutableDictionary dictionaryWithContentsOfFile:levelFilePath];
    NSArray *gameObjectList = [levelContent objectForKey:@"gameobjects"];
    [self applyEffectOnUnits:gameObjectList];
}
 */

@end
