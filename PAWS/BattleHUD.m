//
//  BattleHUD.m
//  PAWS
//
//  Created by Zinan Xing on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BattleHUD.h"
#import "BattleScene.h"
#import "GameManager.h"
#import "AppDelegate.h"

@implementation BattleHUDLayer
@synthesize selSprite = _selSprite;
@synthesize selItem = _selItem;
@synthesize selShadow = _selShadow;
@synthesize selectableUnits;
@synthesize selectableItems;
@synthesize playerCoinsLabel;
@synthesize playerHPLabel;
@synthesize enemyHPLabel;

- (id)init
{
    if( self = [super init] )
    {
        //Get the game manager singleton object
        //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //GameManager *gameMan = [appDelegate gameManager];
        //UserProfile *currentPlayer = [gameMan player]; 
        
        //Item
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ItemList.plist"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CardAtLasV2.plist"];
        
        // Coin
        CCSprite *Coinshow = [CCSprite spriteWithFile:@"CoinAcquireBtn.png" rect:CGRectMake(0, 0, 150, 40)];
        Coinshow.scaleY = 0.6f;
        Coinshow.scaleX = 0.8f;
        Coinshow.position=ccp(400,309);
        [self addChild:Coinshow];
        
        playerCoinsLabel = [CCLabelBMFont labelWithString:
                            [NSString stringWithFormat:@"0"] 
                                              fntFile:@"AppleLiGothic_Black18.fnt"];
        playerCoinsLabel.position = ccp(390, 313);
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *HPbox_self = [CCSprite spriteWithFile:@"HPBar_Self.png"];
        [HPbox_self setAnchorPoint:ccp(0,1)];
        HPbox_self.position = ccp( 0 , size.height );
        [self addChild:HPbox_self z:1];
        
        CCSprite *HPbox_enemy = [CCSprite spriteWithFile:@"HPBar_Enemy.png"];
        [HPbox_enemy setAnchorPoint:ccp(1,1)];
        HPbox_enemy.position = ccp( size.width , size.height );
        [HPbox_enemy setVisible:NO];
        [self addChild:HPbox_enemy z:1];
        
        hpBarCats = [CCSprite spriteWithFile:@"hpbarlabel.png" rect:CGRectMake(0, 0, 80, 10)];
        // hpBarCats.scaleX = 0.3f; //=hp/hpMax
        hpBarCats.anchorPoint=CGPointMake(0.0f, 0.0f);
        hpBarCats.position=ccp(60,305);
        [self addChild:hpBarCats z:2];
        
        hpBarDogs = [CCSprite spriteWithFile:@"hpbarlabel.png" rect:CGRectMake(0, 0, 80, 10)];
        // hpBarDogs.scaleX = 0.8f; //=hp/hpMax
        hpBarDogs.anchorPoint=CGPointMake(0.0f, 0.0f);
        hpBarDogs.position=ccp(353,305);
        [hpBarDogs setVisible:NO];
        [self addChild:hpBarDogs z:2];
        
        /*
        CCSprite *barContainerCat = [CCSprite spriteWithFile:@"BarContainer.png" rect:CGRectMake(0, 0, 120, 20)];
        
        barContainerCat.position=ccp(65,280);
        barContainerCat.scaleY = 0.9f;
        barContainerCat.scaleX = 0.8f;
        [self addChild:barContainerCat z:6];
        
        CCSprite *barContainerDog = [CCSprite spriteWithFile:@"BarContainer.png" rect:CGRectMake(0, 0, 120, 20)];
        
        barContainerDog.position=ccp(420,280);
        barContainerDog.scaleY = 0.9f;
        barContainerDog.scaleX = 0.8f;
        [self addChild:barContainerDog z:6];
        */
        
        /*Temporary one emblem for both side*/
        CCSprite *emblemSelf = [CCSprite spriteWithFile:@"Paws_Emblem.png"];
        CCSprite *emblemEnemy = [CCSprite spriteWithFile:@"Paws_Emblem.png"];
        //Self Emblem
        [emblemSelf setPosition:ccp(26,300)];
        [emblemSelf setScale:0.667];
        [self addChild:emblemSelf z:4];
        //Enemy Emblem
        [emblemEnemy setPosition:ccp(454,300)];
        [emblemEnemy setScale:0.667];
        [emblemEnemy setVisible: NO];
        [self addChild:emblemEnemy z:4];
        
        
        selectableUnits = [[NSMutableArray alloc] init];
        selectableItems = [[NSMutableArray alloc] init];
        [self schedule:@selector(update:) interval:0.1f];
        [self schedule:@selector(updateHPbar:) interval:0.1f];
        
        
        // Added hp label for debug purpose only
        playerHPLabel = [CCLabelBMFont labelWithString:@"HP: 1" fntFile:@"AppleLiGothic_Black18.fnt"];
        playerHPLabel.position = ccp(80, 310);
        
        enemyHPLabel = [CCLabelBMFont labelWithString:@"HP: 1" fntFile:@"AppleLiGothic_Black18.fnt"];
        enemyHPLabel.position = ccp(395, 310);
        [enemyHPLabel setVisible:NO];
        
        [self addChild:playerCoinsLabel z:3];
        [self addChild:playerHPLabel z:3];
        [self addChild:enemyHPLabel z:3];
        
    }
    
    //[self initUnitBuilder];
    
    // Game Loop
    //[self schedule:@selector(gameLogic:) interval:4.0];
    //[self schedule:@selector(update:)];
    
    // Detect touches
    [[CCTouchDispatcher sharedDispatcher] 
     addTargetedDelegate:self 
     priority:0 swallowsTouches:YES];
    return self;
}

#pragma mark -
#pragma mark Drag & Drop Controller
-(void) initUnitBuilderWithArray: (NSMutableArray*) unitArray {
    
    // Create Unit HUD for every unit available
    // Allocate array first
    //_selectableUnits = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    //Use current upgrade
    // Read factor from current upgrade
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    UserProfile *currentPlayer = [gameMan player];
    
    int currentHitPointLevel = [[currentPlayer hitPointLevel] intValue];
    int currentAttackLevel = [[currentPlayer attackDamageLevel] 
                              intValue];
    int currentAttackSpeedLevel = [[currentPlayer attackSpeedLevel] 
                                   intValue];
    int currentSpeedLevel = [[currentPlayer movementSpeedLevel] 
                             intValue];  
    int currentSpawnRateLevel = [[currentPlayer spawnRateLevel] 
                                 intValue];  
    
    //CCLOG(@"Current Hit point level = %d", currentHitPointLevel);
    
    //Read unit levels file from application bundle
    NSString* unitLevelsPath = [[NSBundle mainBundle] pathForResource:@"unitLevels" ofType:@"plist"];
    NSMutableDictionary* unitLevelsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: unitLevelsPath];
    NSMutableArray *levelItemsArray = [[NSMutableArray alloc] initWithArray:[unitLevelsDictionary objectForKey:@"unitLevels"]];
    
    NSMutableArray *hitPointLevels = [[levelItemsArray objectAtIndex:0] 
                                      objectForKey:@"levels"];
    NSMutableArray *attackLevels = [[levelItemsArray objectAtIndex:1] 
                                    objectForKey:@"levels"];
    NSMutableArray *attackSpeedLevels = [[levelItemsArray objectAtIndex:2] 
                                         objectForKey:@"levels"];
    NSMutableArray *speedLevels = [[levelItemsArray objectAtIndex:3] 
                                   objectForKey:@"levels"];
    NSMutableArray *spawnRateLevels = [[levelItemsArray objectAtIndex:4] 
                                       objectForKey:@"levels"];
    
    //Read current upgrade
    float hitPointFactor = 1.0f;
    float attackFactor = 1.0f;
    float attackSpeedFactor = 1.0f;
    float speedFactor = 1.0f;
    float spawnRateFactor = 1.0f;
    for (NSDictionary *upgradeLevel in hitPointLevels) {
        if (
            [[upgradeLevel objectForKey:@"levelID"] intValue] <= 
            currentHitPointLevel
            ) {
            //CCLOG(@"====YES====");
            hitPointFactor *= 1.0 + [[upgradeLevel objectForKey:
                                     @"upgradeFactor"] floatValue];
        }
    }
    for (NSDictionary *upgradeLevel in attackLevels) {
        if (
            [[upgradeLevel objectForKey:@"levelID"] intValue] <= 
            currentAttackLevel
            ) {
            attackFactor *= 1.0 + [[upgradeLevel objectForKey:
                                     @"upgradeFactor"] floatValue];
        }
    }
    for (NSDictionary *upgradeLevel in attackSpeedLevels) {
        if (
            [[upgradeLevel objectForKey:@"levelID"] intValue] <= 
            currentAttackSpeedLevel
            ) {
            attackSpeedFactor *= 1.0 + [[upgradeLevel objectForKey:
                                     @"upgradeFactor"] floatValue];
        }
    }
    for (NSDictionary *upgradeLevel in speedLevels) {
        if (
            [[upgradeLevel objectForKey:@"levelID"] intValue] <= 
            currentSpeedLevel
            ) {
            speedFactor *= 1.0 + [[upgradeLevel objectForKey:
                                     @"upgradeFactor"] floatValue];
        }
    }
    for (NSDictionary *upgradeLevel in spawnRateLevels) {
        if (
            [[upgradeLevel objectForKey:@"levelID"] intValue] <= 
            currentSpawnRateLevel
            ) {
            spawnRateFactor *= 1.0 + [[upgradeLevel objectForKey:
                                     @"upgradeFactor"] floatValue];
        }
    }
    
    CCLOG(@"HP factor= %f", hitPointFactor);
    CCLOG(@"attack factor= %f", attackFactor);
    CCLOG(@"attackSpeed factor= %f", attackSpeedFactor);
    CCLOG(@"speed factor= %f", speedFactor);
    CCLOG(@"spawnRate factor= %f", spawnRateFactor);
    
    
    //CCLOG(@"Count from battle scene is %d", [unitArray count]); 
    for (NSDictionary *element in unitArray) {
        
        for (Card *card in [currentPlayer cards]) {
            if (
                [[card unitType] intValue] 
                == [[element objectForKey:@"id"] intValue]
                || kDebugUnit 
                ) {
                Unit *sprite = [[Unit alloc] initIconWithDictionary:element];
                //Set selectable unit position 
                

                sprite.scale = 0.5f;
                sprite.position = ccp( 
                                      (sprite.contentSize.width *0.5f)*i 
                                      + sprite.contentSize.width*0.5f/2.0f, 
                                      (sprite.contentSize.height*0.5f/2.0f)
                                      );
                
                sprite.cooldownLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", sprite.spawnRate] fontName:@"Arial" fontSize:24.0];
                sprite.cooldownLabel.color = ccc3(255,0,0);
                sprite.cooldownLabel.position = sprite.position;
                sprite.cooldownLabel.visible = YES;
                [sprite setIsFlipX:YES];
                
                //Apply upgrade
                [sprite setHitPoint: (
                                      [sprite hitPoint]
                                      * (hitPointFactor)
                                      )];
                [sprite setAttack: ([sprite attack]* (attackFactor)) ];
                [sprite setAttackSpeed: (
                                         [sprite attackSpeed]
                                         * (attackSpeedFactor)
                                         ) ];
                [sprite setSpeed: (
                                   [sprite speed]
                                   * (speedFactor)
                                   ) ];
                [sprite setSpawnRate: (
                                       [sprite spawnRate]
                                       * (spawnRateFactor)
                                       ) ];
                
                CCLabelBMFont *costLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", [sprite.unitCost intValue]] fntFile:@"AppleLiGothic_Black18.fnt"];
                costLabel.scale = 0.8f;
                costLabel.position = ccp(
                                         sprite.position.x+5.0f,
                                         sprite.position.y-22.0f
                                         );
                
                //playerHPLabel.position = ccp(80, 310);
                [self addChild:sprite.cooldownLabel z:2];
                [self addChild:sprite z:-1];
                [self addChild:costLabel z:-1];
                [selectableUnits addObject:sprite];
                i++;
                break;
            }
        }
        
    }
    
    //BattleScene *parentScene = (BattleScene *) [self parent];
    //selectableUnits = [[NSMutableArray alloc] 
    //                   initWithArray:[parentScene getPlayerUnitArray]];
}

-(void) initItemWithArray:(NSMutableArray *)itemArray {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    UserProfile *currentPlayer = [gameMan player];

    int i = 0;
    for (NSDictionary *element in itemArray) {
        
        if (kDebugUnit) {
        //for (Item *item in [currentPlayer items]) {
            //if (
                //[[item itemType] intValue] == [[element objectForKey:@"id"] intValue]
                //|| kDebugUnit
                //) {
                // Display only unlocked item
                if ([[[element objectForKey:@"frameName"] description] length] > 0) {
                    //CCLOG(@"sprite frame name is %@", [[element objectForKey:@"frameName"] description]);
                    if (
                        [gameMan currentCampaign] == CTCats 
                        && [[element objectForKey:@"id"] intValue] == 8
                        ) {
                        continue;
                    } else if (
                               [gameMan currentCampaign] == CTDogs 
                               && [[element objectForKey:@"id"] intValue] == 1
                               ) {
                        continue;
                    }
                    
                    ItemClass *item = [[ItemClass alloc] 
                                       initWithItemID:[
                                                       [element objectForKey:@"id"] 
                                                       intValue
                                                       ] 
                                       ];
                    
                    [item setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[[element objectForKey:@"frameName"] description]]];
                    item.scale = 0.5f;
                    float offsetX = 55.0f * [selectableUnits count];
                    float offsetY = 22.0f;
                    item.position = ccp(
                                        (
                                         offsetX+(
                                                  item.contentSize.width*i * item.scale
                                                  + item.contentSize.width * item.scale/2
                                                  ) * 1
                                         ), 
                                        offsetY+(item.contentSize.height * item.scale/2)
                                        );
                    
                    CCLabelBMFont *costLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",item.itemCost] fntFile:@"AppleLiGothic_Black18.fnt"];
                    costLabel.scale = 0.8f;
                    costLabel.position = ccp(
                                             item.position.x,
                                             item.position.y-22.0f
                                             );
                    [self addChild:item z:-1];
                    [self addChild:costLabel z:-1];
                    if (item.contentSize.width != 0) {
                        [selectableItems addObject:item];
                        i++;
                    }
                } // if framename
            //} // main if
        //} // for items in db
        } else {
            for (Item *item in [currentPlayer items]) {
            if (
            [[item itemType] intValue] == 
                [[element objectForKey:@"id"] intValue]
            ) {
             //Display only unlocked item
            if ([[[element objectForKey:@"frameName"] description] length] > 0) {
                //CCLOG(@"sprite frame name is %@", [[element objectForKey:@"frameName"] description]);
                if (
                    [gameMan currentCampaign] == CTCats 
                    && [[element objectForKey:@"id"] intValue] == 8
                    ) {
                    continue;
                } else if (
                           [gameMan currentCampaign] == CTDogs 
                           && [[element objectForKey:@"id"] intValue] == 1
                           ) {
                    continue;
                }
                
                ItemClass *item = [[ItemClass alloc] 
                                   initWithItemID:[
                                                   [element objectForKey:@"id"] 
                                                   intValue
                                                   ] 
                                   ];
                /*
                 [item setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[[element objectForKey:@"frameName"] description]]];
                 [item setItemID:[[element objectForKey:@"id"] integerValue]];
                 [item setItemCost:[[element objectForKey:@"cost"] integerValue]];
                 */
                [item setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[[element objectForKey:@"frameName"] description]]];
                item.scale = 0.5f;
                float offsetX = 55.0f * [selectableUnits count];
                float offsetY = 22.0f;
                item.position = ccp(
                                    (
                                     offsetX+(
                                              item.contentSize.width*i * item.scale
                                              + item.contentSize.width * item.scale/2
                                              ) * 1
                                     ), 
                                    offsetY+(item.contentSize.height * item.scale/2)
                                    );
                CCLabelBMFont *costLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",item.itemCost] fntFile:@"AppleLiGothic_Black18.fnt"];
                costLabel.scale = 0.8f;
                costLabel.position = ccp(
                                         item.position.x,
                                         item.position.y-22.0f
                                         );
                [self addChild:item z:-1];
                [self addChild:costLabel z:-1];
                if (item.contentSize.width != 0) {
                    [selectableItems addObject:item];
                    i++;
                }
            } // if framename
            } // main if
            } // for items in db
        }
    }
}

/**
 *  unitMoveEnded
 *  Clean up sprite.
 */
-(void)unitMoveEnded:(id)sender {
    // Remove sprite from scene
    NSLog(@"goal");
    Unit *sprite = (Unit *)sender;
    [self removeChild:sprite cleanup:YES];
}

/**
 *  selectSpriteForTouch
 *  Simple drag and drop controller
 */
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    BattleScene *parentScene = (BattleScene*)[self parent];
    
    Unit * newSprite = nil;
    for (Unit *sprite in selectableUnits) {
        if (
            CGRectContainsPoint([sprite selectionBoundingBox], touchLocation)
            ) {  
            if(
               sprite.spawnCoolDown <= 0
               && [parentScene playerCoin] >= [sprite.unitCost intValue]
               ){
                newSprite = sprite;
                sprite.spawnCoolDown = sprite.spawnRate;
            }
            //NSLog(@"Touched!");
            break;
        }
    }    
    if (newSprite != _selSprite) {
        //[_selSprite stopAllActions];
        
        if (newSprite != nil) {
            Unit *newUnit = nil;
            for (
                 NSMutableDictionary *dict in 
                 [parentScene getPlayerUnitArray]
                 ) 
            {
                if (
                    [[dict objectForKey:@"id"] intValue] ==
                    [newSprite unitID]
                    ) 
                {
                    if (
                        [[dict objectForKey:@"skill"] description] ==
                        @"ghost cat"
                        ) {
                        GhostCat *newGhostCat = [[GhostCat alloc] 
                                                 initWithUnit:newSprite];
                        [newUnit initWithClassName:[[dict objectForKey:@"className"] description] andFlipX:YES];
                        [newGhostCat setPosition:[newSprite position]];
                        [parentScene addChild:newGhostCat];
                        _selSprite = newGhostCat;
                    } else {
                        newUnit = [[Unit alloc] initWithUnit:newSprite];
                        [newUnit initWithClassName:[[dict objectForKey:@"className"] description] andFlipX:YES];
                        newUnit.position = newSprite.position;
                        [parentScene addChild:newUnit];
                        _selSprite = newUnit;
                        Unit* shadow = [[Unit alloc] initWithClassName:[[dict objectForKey:@"className"] description] andFlipX:YES];
                        _selShadow = shadow;
                        //[shadow setOpacity:64];
                        [_selShadow doShadow];
                        [parentScene addChild:shadow];
                    }
                }
            }
        }
    }
    
    ItemClass *itemSprite = nil;
    for (ItemClass *item in selectableItems) {
        float offsetX = (item.contentSize.width*0.75)/2;
        float offsetY = (item.contentSize.height*0.75)/2;
        
        CGRect itemBoundingBox = CGRectMake(
                                            (
                                             item.position.x 
                                            - offsetX
                                             ), 
                                            (item.position.y 
                                            - offsetY
                                            ) , 
                                            item.contentSize.width * 0.75, 
                                            item.contentSize.height * 0.75
                                            );
        //CCLOG(@"Player coin=%d", [parentScene playerCoin]);
        //CCLOG(@"Item cost=%d", item.itemCost);
        if (
            CGRectContainsPoint(itemBoundingBox, touchLocation)
            && item.coolDownTimer <= 0
            && [parentScene playerCoin] >= item.itemCost            
            ) {  
            itemSprite = item;
           // NSLog(@"Touched!");
            break;
        }
    }
    
    if (itemSprite != _selItem) {
        if ( itemSprite != nil) {
            
            ItemClass *newItem = nil;
            newItem = [[ItemClass alloc] 
                                  initWithItemID:itemSprite.itemID];
            
            if ([newItem itemID] == ITEM_PIGGYBANK) {
                [newItem setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"CatProduction.png"]];
                newItem.scale = 0.6f;
            } else if ([newItem itemID] == ITEM_PIGGYBANK_DOG) {
                [newItem setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"DogProduction.png"]];
                newItem.scale = 0.6f;
            } else if ([newItem itemID] == ITEM_FAN) {
                [newItem setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"item_Fan_76.png"]];
                
            } else {
                [newItem setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: newItem.itemFrameName]];
            }
            
            newItem.position = itemSprite.position;
            [parentScene addChild:newItem];
            //[parentScene.items addObject:newItem];
            //CCLOG(@"test %@", newItem.itemFrameName);
            _selItem = newItem;	
        }
    }
    
    // Touch the coin
    //NSMutableArray *coinCollectedArray = [[NSMutableArray alloc] init];
    for (Coin *gameObject in parentScene.gameObjects) {
        float offsetX = (gameObject.contentSize.width*0.75)/2;
        float offsetY = (gameObject.contentSize.height*0.75)/2;
        
        CGRect coinBoundingBox = CGRectMake(
                                            (
                                             gameObject.position.x 
                                             - offsetX
                                             ), 
                                            (gameObject.position.y 
                                             - offsetY
                                             ) , 
                                            gameObject.contentSize.width * 0.75, 
                                            gameObject.contentSize.height * 0.75
                                            );
        if (
            CGRectContainsPoint(coinBoundingBox, touchLocation)
            && [gameObject.type intValue] == kCoinObject
            ) {  
            
            [gameObject setGameObjectState:COLLECTED];
            [gameObject doCollectAction];
            
            break;
        }
    }
    
}

/**
 *  ccTouchBegan
 *  Keep track of touch at starting point.
 */

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];     
    //NSLog(@"Touched!");
    return TRUE;    
}

/**
 *  dropToLane
 *  This method handle dropping new unit.
 */
- (void)dropToLane:(CGPoint)translation {    
    if (_selSprite) {
        CGPoint newPos = ccpAdd(_selSprite.position, translation);
        _selSprite.position = newPos;
        
        // Place shadow
        int fieldHeight = HUD_HEIGHT + 3 * LANE_HEIGHT;
        int firstLane = HUD_HEIGHT ;
        int secondLane = HUD_HEIGHT + LANE_HEIGHT;
        int thirdLane = HUD_HEIGHT + 2 * LANE_HEIGHT;
        if(_selSprite.position.y > HUD_HEIGHT &&  
           _selSprite.position.y <= secondLane){
            _selShadow.visible = YES;
            _selShadow.position = ccp(50.0f, 
                                      firstLane +
                                      kUnitHeight/2
                                      );
        
        } else if (_selSprite.position.y > 
                   secondLane - kUnitHeight/2  && 
                   _selSprite.position.y <= 
                   thirdLane + kUnitHeight/2) {
            _selShadow.visible = YES;
            _selShadow.position = ccp(50.0f, 
                                      secondLane +
                                      kUnitHeight/2
                                      );
        
        } else if ( _selSprite.position.y > thirdLane &&
                   _selSprite.position.y <= 
                   fieldHeight + kUnitHeight/2) {
            _selShadow.visible = YES;
            _selShadow.position = ccp(50.0f, 
                                      thirdLane +
                                      kUnitHeight/2
                                      );
        
        } else {
            _selShadow.visible = NO;
        }
    }
    if (_selItem) {
        CGPoint newPos = ccpAdd(_selItem.position, translation);
        _selItem.position = newPos;
    }
}

/**
 *  ccTouchMoved
 *  If player touches and then drag his finger this method keep track of 2 locations.
 *  And then call method dropToLane to update sprite position.
 */

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self dropToLane:translation];
}

/**
 *  ccTouchEnded
 *  After player release his/her finger set the sprite to fit in the lane.
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_selSprite) {
        //Unit *newUnit = _selSprite;
        int fieldHeight = HUD_HEIGHT + 3 * LANE_HEIGHT;
        int firstLane = HUD_HEIGHT ;
        int secondLane = HUD_HEIGHT + LANE_HEIGHT;
        int thirdLane = HUD_HEIGHT + 2 * LANE_HEIGHT;
        
        BattleScene *parentScene = (BattleScene*)[self parent];
        
        float forceXposition = 0.0;
        
        if( _selSprite.position.y < 
           HUD_HEIGHT || 
           _selSprite.position.y > 
           fieldHeight +kUnitHeight/2){
            // First Remove cooldown that has been applied to this unit
            for (Unit *unit in selectableUnits) {
                if (unit.unitID == _selSprite.unitID) {
                    unit.spawnCoolDown = 0;
                    unit.cooldownLabel.visible = NO;
                }
            }
            [parentScene removeChild:_selSprite cleanup:YES];
            _selSprite = nil;
            [parentScene removeChild:_selShadow cleanup:YES];
            _selShadow = nil;

            
        } else if(_selSprite.position.y > HUD_HEIGHT &&  
                  _selSprite.position.y <= secondLane){ 
            // Sprite y position is in between HUD and second lane.
            _selSprite.position = ccp(forceXposition, 
                                      firstLane +
                                      kUnitHeight/2
                                      );
            // A little bit choppy here but currently is the best way
            // to fixed unit overlap problem. Quick hack.
            [parentScene removeChild:_selSprite cleanup:YES];
            //[parentScene addChild:_selSprite z:3];
            [_selSprite setPath: [NSNumber numberWithInt:1]];
            [parentScene addPlayerUnitwithUnit:_selSprite 
                                     andOnLane:3];
            [parentScene removeChild:_selShadow cleanup:YES];
            _selShadow = nil;

        } else if(_selSprite.position.y > 
                  secondLane - kUnitHeight/2  && 
                  _selSprite.position.y <= 
                  thirdLane + kUnitHeight/2){ 
            // Sprite y position is in between first lane and third lane.
            _selSprite.position = ccp(forceXposition, secondLane + 
                                      kUnitHeight/2);
            [parentScene removeChild:_selSprite cleanup:YES];
            //[parentScene addChild:_selSprite z:2];
            [_selSprite setPath: [NSNumber numberWithInt:2]];
            [parentScene addPlayerUnitwithUnit:_selSprite 
                                     andOnLane:2];
            [parentScene removeChild:_selShadow cleanup:YES];
            _selShadow = nil;
        } else if(_selSprite.position.y > thirdLane &&
                  _selSprite.position.y <= 
                  fieldHeight + kUnitHeight/2){ 
            // Sprite y position is in between first lane and third lane.
            _selSprite.position = ccp(forceXposition, thirdLane + 
                                      kUnitHeight/2);
            [parentScene removeChild:_selSprite cleanup:YES];
            //[parentScene addChild:_selSprite z:1];
            [_selSprite setPath: [NSNumber numberWithInt:3]];
            [parentScene addPlayerUnitwithUnit:_selSprite 
                                     andOnLane:1];
            [parentScene removeChild:_selShadow cleanup:YES];
            _selShadow = nil;

        } 
        
        //[_selSprite stopAllActions];
        if(_selSprite) {
            
            for (Unit *unit in selectableUnits) {
                if (unit.unitID == _selSprite.unitID) {
                    //unit.spawnCoolDown = 0;
                    unit.cooldownLabel.visible = YES;
                }
            }
            parentScene.playerCoin -= [_selSprite.unitCost intValue];
            [self updateCoin];
        }
        // This line release _selSprite from newly created sprite.
        _selSprite = nil;
    }
    
    if (_selItem) {
        int fieldHeight = HUD_HEIGHT + 3 * LANE_HEIGHT+5;
        int firstLane = HUD_HEIGHT +5;
        int secondLane = HUD_HEIGHT + LANE_HEIGHT+5;
        int thirdLane = HUD_HEIGHT + 2 * LANE_HEIGHT+5;
        
        BattleScene *parentScene = (BattleScene*)[self parent];
        float forceXposition =_selItem.position.x;
        
        for (ItemClass *item in parentScene.items) {
            if (CGRectContainsPoint(
                                    [item adjustedBoundingBox], 
                                    ccp(forceXposition, _selItem.position.y)
                                    )
                ) {
                [parentScene removeChild:_selItem cleanup:YES];
                _selItem = nil;
                return;
            }
        }
        
        
        if( _selItem.position.y < 
           HUD_HEIGHT || 
           _selItem.position.y > 
           fieldHeight +kUnitHeight/2){
            // First Remove cooldown that has been applied to this item
            /*
            for (ItemClass *item in selectableItems) {
                if (item.itemID == _selItem.itemID) {
                    item.coolDown = 0;
                    //item.cooldownLabel.visible = NO;
                }
            }
             */
            [parentScene removeChild:_selItem cleanup:YES];
            _selItem = nil;
            
        } else if(_selItem.position.y > HUD_HEIGHT &&  
                  _selItem.position.y <= secondLane){ 
            // Sprite y position is in between HUD and second lane.
            _selItem.position = ccp(forceXposition, 
                                      firstLane +
                                      kUnitHeight/2
                                      );
            // A little bit choppy here but currently is the best way
            // to fixed unit overlap problem. Quick hack.
            [parentScene removeChild:_selItem cleanup:YES];
            [_selItem setPath: [NSNumber numberWithInt:1]];
            
            [parentScene addChild:_selItem z:3];
        } else if(_selItem.position.y > 
                  secondLane - kUnitHeight/2  && 
                  _selItem.position.y <= 
                  thirdLane + kUnitHeight/2){ 
            // Sprite y position is in between first lane and third lane.
            _selItem.position = ccp(forceXposition, secondLane + 
                                      kUnitHeight/2);
            [parentScene removeChild:_selItem cleanup:YES];
            [_selItem setPath: [NSNumber numberWithInt:2]];
            [parentScene addChild:_selItem z:2];
        } else if(_selItem.position.y > thirdLane &&
                  _selItem.position.y <= 
                  fieldHeight + kUnitHeight/2){ 
            // Sprite y position is in between first lane and third lane.
            _selItem.position = ccp(forceXposition, thirdLane + 
                                      kUnitHeight/2);
            [parentScene removeChild:_selItem cleanup:YES];
            [_selItem setPath: [NSNumber numberWithInt:3]];
            [parentScene addChild:_selItem z:1];
        }
        
        if (_selItem) {
            if ([_selItem itemID] == ITEM_CATAPULT) {
                Catapult *item = [[Catapult alloc] initWithItemID:_selItem.itemID];
                [item setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"item_Stone_76.png"]];
                item.position = _selItem.position;
                [parentScene removeChild:_selItem cleanup:YES];
                //_selItem = nil;
                //_selItem = item;
                [parentScene.items addObject:item];
                [parentScene addChild:item z:_selItem.zOrder];
                [item doCatapult];
                //item = nil;

            } else {
                [parentScene.items addObject:_selItem];
            }
            
            parentScene.playerCoin -= _selItem.itemCost;
            
            for (ItemClass *item in selectableItems) {
                if (item.itemID == _selItem.itemID) {
                    item.coolDownTimer = item.coolDown;
                }
            }
            
            if ([_selItem itemID] == ITEM_FAN) {
                [_selItem runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.1f angle:360]]];
            }
            
            [self updateCoin];
            
        }
        
        //release
        _selItem = nil;
    }
}

#pragma mark -
#pragma mark Update Function
-(void) update:(ccTime)dt {
    BattleScene *parentScene = (BattleScene *) [self parent];
    [playerHPLabel setString:
     [NSString stringWithFormat:@"Life: %d", [parentScene playerHP]]];
    [enemyHPLabel setString:
     [NSString stringWithFormat:@"Life: %d", [parentScene enemyHP]]];
    
    for (Unit* unit in selectableUnits) {
        if (unit.spawnCoolDown > 0 && unit.cooldownLabel.visible == YES) {

            [unit.cooldownLabel 
             setString:[NSString stringWithFormat: @"%.1f", 
                        [unit spawnCoolDown ]]];
            unit.spawnCoolDown -= 0.1f;
            
        }else {
            unit.cooldownLabel.visible = NO;
        }
    }
    
    for (ItemClass *item in selectableItems) {
        if (item.coolDownTimer > 0 ) {
            item.coolDownTimer -= 0.1f;
        }
    }
}

-(void) draw
{
    BattleScene *parentScene = (BattleScene *) [self parent];
    float span= 55.0f *0.5f;
    for (Unit* unit in selectableUnits) {
        if (unit.spawnCoolDown > 0 && unit.cooldownLabel.visible == YES) {
            glEnable(GL_LINE_SMOOTH);
            glEnable (GL_BLEND);
            glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glColor4ub(255, 255, 255, 180);
            glLineWidth(2);
            
            int xloc=unit.cooldownLabel.position.x;
            int yloc=unit.cooldownLabel.position.y;
            //int span=30;
            int cardheight=unit.spawnCoolDown*2*span/unit.spawnRate;
            CGPoint vertices2[] = {ccp(xloc-span, yloc-span),
                ccp(xloc+span, yloc-span),
                ccp (xloc+span, cardheight),
                ccp (xloc-span, cardheight)};
            
            
            
            ccDrawPoly(vertices2, 4, YES);
            //ccFillPoly(vertices2, 4, YES); 
            
            [self ccFillPoly:vertices2 withPointCount:4 isClosed:YES];
            
        } else if ( parentScene.playerCoin < [unit.unitCost intValue]) {
            glEnable(GL_LINE_SMOOTH);
            glEnable (GL_BLEND);
            glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glColor4ub(0, 0, 0, 128);
            glLineWidth(2);
            
            int xloc=unit.cooldownLabel.position.x;
            int yloc=unit.cooldownLabel.position.y;
            //int span=30;
            int cardheight=2*span;
            CGPoint vertices2[] = {ccp(xloc-span, yloc-span),
                ccp(xloc+span, yloc-span),
                ccp (xloc+span, cardheight),
                ccp (xloc-span, cardheight)};
            
            
            
            ccDrawPoly(vertices2, 4, YES);
            [self ccFillPoly:vertices2 withPointCount:4 isClosed:YES];
            //ccFillPoly(vertices2, 4, YES); 
        } else if ( parentScene.playerCoin >= [unit.unitCost intValue]) {
            glEnable(GL_LINE_SMOOTH);
            glEnable (GL_BLEND);
            glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glColor4ub(255, 255, 255, 180);
            glLineWidth(2);
            
            int xloc=unit.cooldownLabel.position.x;
            int yloc=unit.cooldownLabel.position.y;
            
            int cardheight=0;
            CGPoint vertices2[] = {ccp(xloc-span, yloc-span),
                ccp(xloc+span, yloc-span),
                ccp (xloc+span, cardheight),
                ccp (xloc-span, cardheight)};
            
            
            
            ccDrawPoly(vertices2, 4, YES);
            [self ccFillPoly:vertices2 withPointCount:4 isClosed:YES];
            //ccFillPoly(vertices2, 4, YES); 
        } else {
            unit.cooldownLabel.visible = NO;
        }
    }
    
    for (ItemClass *item in selectableItems) {
        if (item.coolDownTimer > 0) {
            // draw poly
            glEnable(GL_LINE_SMOOTH);
            glEnable (GL_BLEND);
            glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glColor4ub(0, 0, 0, 180);
            glLineWidth(2);
            
            ccDrawCircle(ccp(item.position.x, item.position.y), 15.0, CC_DEGREES_TO_RADIANS(item.coolDownTimer/(float)item.coolDown *360.0f), 1000, YES);
        } else if ( parentScene.playerCoin < item.itemCost) {
            // draw poly
            glEnable(GL_LINE_SMOOTH);
            glEnable (GL_BLEND);
            glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glColor4ub(255, 255, 255, 180);
            glLineWidth(2);
            ccDrawCircle(ccp(item.position.x, item.position.y), 15.0, CC_DEGREES_TO_RADIANS(360.0), 1000, YES);
            
        } else if (parentScene.playerCoin >= item.itemCost ) {
            // draw poly
            glEnable(GL_LINE_SMOOTH);
            glEnable (GL_BLEND);
            glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glColor4ub(255, 255, 255, 180);
            glLineWidth(2);
            ccDrawCircle(ccp(item.position.x, item.position.y), 15.0, CC_DEGREES_TO_RADIANS(0), 0, NO);
        }
        
    }
    
    if (_selItem && _selItem.itemID == ITEM_CATAPULT) {
        //
        // draw poly
        glEnable(GL_LINE_SMOOTH);
        glEnable (GL_BLEND);
        glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glColor4ub(0, 0, 0, 255);
        glLineWidth(2);
        ccDrawCircle(ccp(_selItem.position.x, _selItem.position.y), 100.0, CC_DEGREES_TO_RADIANS(360.0), 360, NO);
    }
}

-(void) ccFillPoly:(CGPoint*)poli withPointCount:(int)points isClosed:(BOOL)closePolygon
{
    //[self ccFillPoly:myPointObj withPointCount:10 isClosed:true];
    
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states: GL_VERTEX_ARRAY,
    // Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, 0, poli);
    if( closePolygon )
        //	 glDrawArrays(GL_LINE_LOOP, 0, points);
        glDrawArrays(GL_TRIANGLE_FAN, 0, points);
    else
        glDrawArrays(GL_LINE_STRIP, 0, points);
    
    
    // restore default state
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
}




-(void) updateHPbar:(ccTime)dt {
    BattleScene *parentScene = (BattleScene *) [self parent];
    [hpBarCats setScaleX:([parentScene playerHP]/3.0)];
    [hpBarDogs setScaleX:([parentScene enemyHP]/20.0)];
}

-(void) updateCoin {
    //Get the game manager singleton object
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //GameManager *gameMan = [appDelegate gameManager];
    //UserProfile *currentPlayer = [gameMan player];
    
    BattleScene *parentScene = (BattleScene *) [self parent];
    
    [playerCoinsLabel setString: [NSString stringWithFormat:@"%d", [parentScene playerCoin]]];
}

-(void) dealloc{
    [playerHPLabel release];
    playerHPLabel = nil;
    [enemyHPLabel release];
    enemyHPLabel = nil;
    [super dealloc];
}



@end
