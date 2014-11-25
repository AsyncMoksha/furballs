//
//  BattleLayer.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 9/25/11.
//  Copyright 2011 Pulse. All rights reserved.
//
// TODO: (Poom)
// - Add all units (7 unit)
// - Implement all skills (1/11)
// - Create first version of each level

#import "BattleLayer.h"
#import "BattleScene.h"

@implementation BattleLayer
@synthesize enemy = _enemy;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;
@synthesize selectableUnits = _selectableUnits;
@synthesize gameObjectsWaitingToSpawn;
@synthesize projectileObjects;
@synthesize gameTime;
@synthesize levelTime;
@synthesize clock;
@synthesize isGameStarted;
@synthesize levelSpeedFactor;

- (id)init
{
    return [self initWithLevelID:-1];
}

//Inits the scene with the level ID
-(id) initWithLevelID:(NSInteger)lid 
{
    if( self = [super init] ){
        //Load every sprite from the begining to cache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat1ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat2ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat3ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat4ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat5ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat6ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cat7ProcAtlas.plist"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog1ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog2ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog3ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog4ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog5ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog6ProcAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dog7ProcAtlas.plist"];
        //Coin atlas file
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"coinAtlas.plist"];
        
        // New Items
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ItemSprites.plist"];
        
        // Item icons and Projectiles
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"itemButtons.plist"];
        
        //Initialize unit arrays
        //[self initUnit];
    }
    
    gameTime = 0;
    
    _enemyUnits =  [[NSMutableArray alloc] init];
    _playerUnits =  [[NSMutableArray alloc] init];
    [self setGameObjectsWaitingToSpawn:[[NSMutableArray alloc] init]];
    
    //Load the list of game objects waiting to be spawed
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GameManager *gameMan = [appDelegate gameManager];
    //UserProfile *currentPlayer = [gameMan player];
    NSString *levelFileName = [NSString string];
    if(lid < 0)
        levelFileName = @"levelCat1";
    else {
        //levelFileName = [NSString stringWithFormat:@"level%d", lid]; 
        if ([gameMan currentCampaign] == CTCats) {
            levelFileName = [NSString stringWithFormat:@"levelCat%d", lid];
        } else {
            levelFileName = [NSString stringWithFormat:@"levelDog%d", lid];
        }
    }
    
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:levelFileName ofType:@"plist"];
    NSDictionary *levelContent = [NSMutableDictionary dictionaryWithContentsOfFile:levelFilePath];
    NSArray *gameObjectList = [levelContent objectForKey:@"gameobjects"];
    
    levelSpeedFactor = [[levelContent objectForKey:@"speedFactor"] floatValue];
    levelTime = [[levelContent objectForKey:@"leveltime"] intValue];
    
    
    for(NSDictionary* gameObjDict in gameObjectList)
    {
        GameObject* newGameObj = nil;
        if ([[gameObjDict valueForKey:@"Type"] integerValue] == kCoinObject) {
            newGameObj = [[Coin alloc] initWithDictionary:gameObjDict];
        } else {
            newGameObj = [[GameObject alloc] initWithDictionary:gameObjDict];
        }
        
        [[self gameObjectsWaitingToSpawn] addObject:newGameObj];
    }
    
    clock = [CCLabelBMFont labelWithString: 
             [NSString stringWithFormat:@"Time:%d", (levelTime-gameTime)] 
                                   fntFile:@"AppleLiGothicBrown18.fnt"];
    [clock setAnchorPoint:ccp(0,1)];
    CGSize size = [[CCDirector sharedDirector] winSize];
    clock.position = ccp(size.width/2.0,321.0f);
    [self addChild:clock z:10];
    
    // Generate coin every 3 seconds.
    [self generateCoin];
    
    // Initialize projectileObjects
    projectileObjects = [[NSMutableArray alloc] init];
    
    
    
    // Game Loop
    //[self schedule:@selector(gameLogic:) interval:1.0];
    //[self schedule:@selector(update:)];
    //[self scheduleUpdate];
    
    //Detect Begining Pause game
    self.isGameStarted = false;
    // Detect touches
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    return self;
}

+(id) nodeWithLevelID:(NSInteger)lid
{
    return [[[self alloc] initWithLevelID:lid ] autorelease];
}

#pragma mark -
#pragma mark Schdule game logic
-(void) startScheduleGameLogic{
    // Enemy Generator
    [self schedule:@selector(generateEnemy:) interval:1.0];
    // Game Loop
    [self schedule:@selector(gameLogic:) interval:1.0];
    [self scheduleUpdate];
    self.isGameStarted = true;
    
}
#pragma mark -
#pragma mark Battle Logic

/**
 *  addEnemy
 *  Simple enemy generator (placeholder) for testing battle logic.
 *  Basically, it create simple animation from basic sprite and move to 
 *  left edge of screen.
 *  Update: Use array from battle scene instead. This method is obsolete
 */
- (void)addEnemy{
    
    // Randomly generate enemy from dog units for now.
    
    //Unit *enemy = [CCSprite spriteWithFile:@"cat1.png" rect:CGRectMake(0, 0, 94, 84)];
    Unit *enemy = nil;
    
    /* This is a placeholder. We should generate enemies based on level design. 
        For now, I will generate dog first unit every time.
     */
    BattleScene *parentScene = (BattleScene*)[self parent];
    NSMutableArray *enemyUnits = [parentScene getEnemyUnitArray];
    // Use array from battle scene instead
    for (NSDictionary *element in enemyUnits) {
        enemy = [[Unit alloc] initWithDictionary:element andIsFlipX:NO];
        break;
    }
    // Change state into WALK
    //int randomLane = (arc4random() % 3) + 1;
    int randomLane = 1;
    int actualY = LANE_HEIGHT*randomLane+HUD_HEIGHT;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    enemy.position = ccp(winSize.width, actualY);
    
    enemy.isFlipX = NO;
    [enemy setState:WALK];
    
    //Generate HP Label
    enemy.hpLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP:%d", enemy.hitPoint] fontName:@"Arial" fontSize:14.0];
    enemy.hpLabel.color = ccc3(255,255,255);
    enemy.hpLabel.position = enemy.position;
  
    enemy.hpLabel = [CCSprite spriteWithFile:@"hpbarlabel.png" rect:CGRectMake(0, 0, 50, 15)];
    enemy.hpLabel.color = ccc3(200,0,8);
    enemy.hpLabel.position = enemy.position;
    
      
    
    
    
    [self addChild:enemy.hpLabel];
    /*
    //Set Move Action
    float moveDuration = 30.0 / enemy.speed;
    CCAction *moveAction = [CCSequence actions:                          
                            [CCMoveTo actionWithDuration:moveDuration position:ccp(-enemy.contentSize.width/2, actualY)],
                            [CCCallFunc actionWithTarget:self selector:@selector(unitMoveEnded:)],nil];
    [moveAction setTag:MOVE_ACTION];
    [enemy runAction:moveAction];
     */
    
    //Add enemy into array
    [_enemyUnits addObject:enemy];
    NSLog(@"enemy units: %d", [_enemyUnits count]);
    [self addChild:enemy];
}

- (void)addEnemyToLane:(NSInteger)lane andWithUnit:(GameObject *)unit
{
    // Randomly generate enemy from dog units for now.
    BattleScene *parentScene = (BattleScene*)[self parent];
    NSMutableArray *enemyUnits = [parentScene getEnemyUnitArray];
    //_enemyUnits = [parentScene enemyUnits];
    
    //Unit *enemy = [CCSprite spriteWithFile:@"cat1.png" rect:CGRectMake(0, 0, 94, 84)];
    Unit *enemy = nil;
    
    // Changed to reflex singleton design.
    // Now all the unit arrays are reside in BattleScene and
    // accessible for every child layer.
    for (NSDictionary *element in enemyUnits) {
        if ( 
            ([[element valueForKey:@"id"] intValue] % 10) == 
            [[unit type] intValue]
            ) {
        //CCLOG(@"Unit id is %d", [[element valueForKey:@"id"] intValue]);
            enemy = [[Unit alloc] initWithDictionary:element andIsFlipX:NO];
            break;
        }
        
    }
    if (enemy != nil) {
        int actualY = LANE_HEIGHT * (lane-1)
                        +HUD_HEIGHT 
                        + kUnitHeight/2;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        enemy.position = ccp(winSize.width, actualY);
        
        enemy.isFlipX = NO;
        [enemy setState:WALK];
        
        //Generate HP Label
        /*
        enemy.hpLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP:%d", enemy.hitPoint] fontName:@"Arial" fontSize:14.0];
        enemy.hpLabel.color = ccc3(255,255,255);
        enemy.hpLabel.position = enemy.position;
        */
        enemy.hpLabel = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"HP:%d", enemy.hitPoint] 
                               fntFile:@"AppleLiGothicBrown18.fnt"];
        [enemy.hpLabel setAnchorPoint:ccp(0,1)];
        [self addChild:enemy.hpLabel];
        
        //Add enemy into array
        [enemy setPath:[NSNumber numberWithInt:lane]];
        [parentScene addEnemyUnitwithUnit:enemy andOnLane:(4-lane)];
        // Added lane as z so unit with lower lane will be on top of others
        //[parentScene addChild:enemy z:(4-lane)];
    }
    
}

- (void)addObjectToLane:(NSInteger)lane andWithObject:(GameObject *) object {
    BattleScene *parentScene = (BattleScene*)[self parent];
    //NSMutableArray *gameObjects = [parentScene getGameObjectArray];
    //_enemyUnits = [parentScene enemyUnits];
    
    int actualY = LANE_HEIGHT * (lane-1)
    +HUD_HEIGHT 
    + kUnitHeight/2;
    CCAction *dropAction = [CCMoveTo actionWithDuration:3.0 
                                     position:ccp(
                                                  object.position.x, 
                                                  actualY
                                                  ) ];
    [dropAction setTag:MOVEACTION];
    [object runAction:dropAction];
    [parentScene addGameObject:object];
    [parentScene addChild:object z:lane];
}

- (void)update:(ccTime)dt {
    //NSLog(@"test");
    BattleScene *parentScene = (BattleScene*)[self parent];

    // Player unit logic
    
    NSMutableArray *playerToBeRemove = [[NSMutableArray alloc] init ];
    NSMutableArray *playerToBeAdded = [[NSMutableArray alloc] init ];
    for (Unit* playerUnit in [parentScene playerUnits]) {
        
        // Do battle logic
        if (
            [playerUnit unitID] == kGhostCatUnit
            //|| [playerUnit unitID] == kJumpingCatUnit
            || [playerUnit unitID] == kHealerCatUnit
            || [playerUnit unitID] == kSiberianHusky
            ) {
            //playerUnit = (GhostCat *) playerUnit;
            //CCLOG(@"Do ghost Cat");
            [playerUnit updateStateWithDeltaTime:dt
                              andListOfAllyUnits:[parentScene playerUnits]
                             andListOfEnemyUnits:[parentScene enemyUnits]];
        } else if ( [playerUnit unitID] == kPuddle ){
            if ([(PuddleDog *)playerUnit summonCooldown] == 0) {
                // Do summon
                //CCLOG(@"test Summon");
                NSMutableArray *playerUnits=[parentScene getPlayerUnitArray];
                Unit *summonUnit = nil;
                
                //int randomUnit = (arc4random() % [enemyUnits count]);
                for (NSDictionary *element in playerUnits) {
                    
                    if ([[element objectForKey:@"id"] intValue] == 11) {
                        summonUnit = [[Unit alloc] 
                                      initWithDictionary:element 
                                      andIsFlipX: [playerUnit isFlipX]];
                        break;
                    }
                    
                    
                }
                summonUnit.position = playerUnit.position;
                summonUnit.path = [NSNumber numberWithInt:playerUnit.zOrder];
                //[parentScene addPlayerUnitwithUnit:summonUnit 
                //                         andOnLane:playerUnit.zOrder];
                [playerToBeAdded addObject:summonUnit];
            }
            [playerUnit updateStateWithDeltaTime:dt
                             andListOfEnemyUnits:[parentScene enemyUnits]];
        
        } else if ( [playerUnit unitID] == kThrowingCatUnit) {
            // Add projectile
            [playerUnit updateStateWithDeltaTime:dt
                             andListOfEnemyUnits:[parentScene enemyUnits]];
            if ([playerUnit coolDown] == 0 && [playerUnit isBattleStance]) {
                ProjectileObject *projectile = [[ProjectileObject alloc] initWithUnit:playerUnit];
                [projectile doMoveAction];
                [parentScene addChild:projectile 
                                    z:[[projectile path] intValue]];
                [parentScene addChild:projectile.shadowSprite];
                [projectileObjects addObject:projectile];
                CCLOG(@"Throw!");
                playerUnit.coolDown = playerUnit.attackSpeed;
            }
            
        
        } else { // Normal unit
            [playerUnit updateStateWithDeltaTime:dt
                             andListOfEnemyUnits:[parentScene enemyUnits]];
        }
        
        
        if( [playerUnit state] == DEAD 
           && [playerUnit numberOfRunningActions] == 0
           ) {
            //[parentScene removePlayerUnit:playerUnit];
            [playerToBeRemove addObject:playerUnit];
            continue;
        }
        
        if( [playerUnit state] == FINISHED ) {
            
            [parentScene decreaseEnemyHP];
            [parentScene checkBattleResult];  //Check if you win or not
            //[parentScene removePlayerUnit:playerUnit];
            [playerToBeRemove addObject:playerUnit];
            continue;
        }
        //[playerUnit printState:[playerUnit state]];
        
    }//<!-- end of player units for loop -->
    
    for (Unit *playerUnit in playerToBeRemove) {
        [parentScene removePlayerUnit:playerUnit];
    }
    
    for (Unit *unit in playerToBeAdded) {
        [parentScene addPlayerUnitwithUnit:unit 
                                 andOnLane:[unit.path intValue]];
    }
    
    
    // Now change to update on enemy's side
    
    NSMutableArray *enemyToBeRemove = [[NSMutableArray alloc] init ];
    NSMutableArray *enemyToBeFlipped = [[NSMutableArray alloc] init ];
    NSMutableArray *enemyToBeAdded = [[NSMutableArray alloc] init ];
    
    for (Unit* enemyUnit in [parentScene enemyUnits]) {
        
        // Do battle logic for enemy units
        if (
            [enemyUnit unitID] == kGhostCatUnit
            //|| [playerUnit unitID] == kJumpingCatUnit
            || [enemyUnit unitID] == kHealerCatUnit
            ) {
            [enemyUnit updateStateWithDeltaTime:dt
                              andListOfAllyUnits:[parentScene enemyUnits]
                             andListOfEnemyUnits:[parentScene playerUnits]];
        } else if ( [enemyUnit unitID] == kThrowingCatUnit) {
            // Add projectile
            [enemyUnit updateStateWithDeltaTime:dt
                             andListOfEnemyUnits:[parentScene playerUnits]];
            if ([enemyUnit coolDown] == 0 && [enemyUnit isBattleStance]) {
                ProjectileObject *projectile = [[ProjectileObject alloc] initWithUnit:enemyUnit];
                [projectile doMoveAction];
                [parentScene addChild:projectile 
                                    z:[[projectile path] intValue]];
                [projectileObjects addObject:projectile];
                enemyUnit.coolDown = enemyUnit.attackSpeed;
            }
            
        } else if ( [enemyUnit unitID] == kPuddle ){
            if ([(PuddleDog *)enemyUnit summonCooldown] == 0) {
                // Do summon
                //CCLOG(@"test Summon");
                NSMutableArray *enemyUnits=[parentScene getEnemyUnitArray];
                Unit *summonUnit = nil;
                
                //int randomUnit = (arc4random() % [enemyUnits count]);
                for (NSDictionary *element in enemyUnits) {
                    
                    if ([[element objectForKey:@"id"] intValue] == kFastDog) {
                        summonUnit = [[Unit alloc] 
                                      initWithDictionary:element 
                                      andIsFlipX: [enemyUnit isFlipX]];
                        break;
                    }
                    
                    
                }
                summonUnit.position = enemyUnit.position;
                summonUnit.path = [NSNumber numberWithInt:enemyUnit.zOrder];
                if (summonUnit != nil) {
                    [enemyToBeAdded addObject:summonUnit];
                }
                
                //[parentScene addEnemyUnitwithUnit:summonUnit 
                //                         andOnLane:enemyUnit.zOrder];
            }
            [enemyUnit updateStateWithDeltaTime:dt
                             andListOfEnemyUnits:[parentScene playerUnits]];
            
        } else { // Normal unit
            [enemyUnit updateStateWithDeltaTime:dt
                             andListOfEnemyUnits:[parentScene playerUnits]];
        }
        
        // Check against item
        [enemyUnit updateStateWithDeltaTime:dt 
                             andListOfItems:[parentScene items]];
        
        if( [enemyUnit state] == DEAD 
           && [enemyUnit numberOfRunningActions] == 0
           ) {
            //[parentScene removeEnemyUnit:enemyUnit];
            [enemyToBeRemove addObject:enemyUnit];
            continue;
        }
        
        if( [enemyUnit state] == FINISHED ) {
            
            [parentScene decreasePlayerHP];
            [parentScene checkBattleResult];  //Check if you win or not
            //[parentScene removeEnemyUnit:enemyUnit];
            [enemyToBeRemove addObject:enemyUnit];
            continue;
        }
        if ([enemyUnit state] == FLIP) {
            [enemyToBeFlipped addObject:enemyUnit];
        }
        [enemyUnit updateStateWithDeltaTime:dt 
                        andListOfEnemyUnits:[parentScene playerUnits]];
    }//<!-- end of enemy units for loop -->
    
    for (Unit *enemy in enemyToBeRemove) {
        [parentScene removeEnemyUnit:enemy];
    }
    
    for (Unit *enemy in enemyToBeFlipped) {
        //[parentScene removeEnemyUnit:enemy];
        [[parentScene enemyUnits] removeObject:enemy];
        [[parentScene playerUnits] addObject:enemy];
        [enemy setState:IDLE];
    }
    
    for (Unit *enemy in enemyToBeAdded) {
        [parentScene addEnemyUnitwithUnit:enemy 
                                 andOnLane:[enemy.path intValue]];
    }
    
    
    // Coin
    for (Coin* gameObject in [parentScene gameObjects]) {
        [gameObject updateStateWithDeltaTime: dt 
                        andListOfPlayerUnits: [parentScene playerUnits]
                         andListOfEnemyUnits: [parentScene enemyUnits]];
        
    }
    
    [parentScene cleanupCoinObject];
    
    // Item logic
    NSMutableArray *itemToBeRemoved = [[NSMutableArray alloc] init ];
    
    for (ItemClass *item in [parentScene items]) {
        if (
            [item gameObjectState] == REMOVED 
            //&& [item numberOfRunningActions] == 0
            ) {
            //item.effectDuration = 0;
            [itemToBeRemoved addObject:item];
            continue;
        }
        
         NSMutableArray *affectedUnits = [[NSMutableArray alloc] init];
        //CCLOG(@"catapult position is %.2f, %.2f", item.position.x, item.position.y);
        if (
            [item itemID] == ITEM_CATAPULT
            ) {
            if (
                [item numberOfRunningActions] == 0
                ) {
                
            CCLOG(@"catapult position is %.2f, %.2f", item.position.x, item.position.y);
            for (Unit *unit in [parentScene enemyUnits]) {
                CCLOG(@"test catapult loop");
                if( ccpDistance(item.position, unit.position) 
                    <= 100.0f) {
                    //apply catapult effect to unit.
                    CCLOG(@"Add unit to catapult range");
                    [affectedUnits addObject:unit];
                }
            }
                //[item setGameObjectState:REMOVED];
                //[itemToBeRemoved addObject:item];
                
                [(Catapult *)item applyEffectOnUnits:affectedUnits];
            }
            
            
            
            continue;
        }
        
        if ( // Piggy bank logic
            [item itemID] == ITEM_PIGGYBANK 
            || [item itemID] == ITEM_PIGGYBANK_DOG
            ) {
            
            if (item.coolDownTimer <= 0) {
                // Do generate coins
                Coin *coin = [[Coin alloc] 
                              initWithRandomPositionWithTime:gameTime+1];
                coin.scale = 0.5f;
                [gameObjectsWaitingToSpawn addObject:coin];
                item.coolDownTimer = kCoinRate;
            }
            
            if (item.effectDuration <= 0) {
                //[[parentScene items] removeObject:item];
                [itemToBeRemoved addObject:item];
                //[parentScene removeChild:item cleanup:YES];
            }
            continue;
        }
       
        
        // Wind Item logic
        for (Unit *unit in [parentScene enemyUnits]) {
            if (unit.path == item.path) {
                
                if (item.effectDuration <= 0) {
                    // Remove effect
                    if (unit.itemStatus != NONE) {
                        [affectedUnits addObject:unit];
                        [unit setItemStatus:NONE];
                    }
                } else {
                    // Add effect
                    if (unit.itemStatus == NONE) {
                        [affectedUnits addObject:unit];
                        if (
                            item.itemID == ITEM_FAN 
                            ) {
                            [unit stopActionByTag:MOVEACTION];
                            [unit setState:IDLE];
                            unit.itemStatus = WIND;

                        }
                    }
                    
                }
            }
        }
        if (item.effectDuration <= 0) {
            [item removeEffectOnUnits:affectedUnits];
            //[[parentScene items] removeObject:item];
            [itemToBeRemoved addObject:item];
            //[parentScene removeChild:item cleanup:YES];
        } else {
            //CCLOG(@"Apply effect!");
            [item applyEffectOnUnits:affectedUnits];
            
        } 
    }
    for (ItemClass *item in itemToBeRemoved) {
        [[parentScene items] removeObject:item];
        [parentScene removeChild:item cleanup:YES];
    }
    
    
    //Projectile update
    NSMutableArray *projectileToBeRemoved = 
                                    [[NSMutableArray alloc] init];
    for (ProjectileObject *proj in projectileObjects) {
        [proj updateStateWithDeltaTime:dt 
                   andListOfEnemyUnits: [parentScene enemyUnits]];
        
        if ([proj gameObjectState] == REMOVED) {
            [parentScene removeChild:proj cleanup:YES];
            [parentScene removeChild:proj.shadowSprite cleanup:YES];
            [projectileToBeRemoved addObject:proj];
            //[projectileObjects removeObject:proj];
        }
    }
    // Remove from array
    for (ProjectileObject *proj in projectileToBeRemoved) {
        [projectileObjects removeObject:proj];
    }
}//<!-- End of function -->

-(void)gameLogic: (ccTime)dt {
    BattleScene *parentScene = (BattleScene*)[self parent];
    for (Unit *playerUnit in [parentScene playerUnits]) {
        [playerUnit updateCoolDown];
    }
    for (Unit *enemyUnit in [parentScene enemyUnits]) {
        [enemyUnit updateCoolDown];
    }
    for (Unit *selectableUnit in _selectableUnits) {
        [selectableUnit updateCoolDown];
    }
    
    for (ItemClass *item in [parentScene items]) {
        item.effectDuration--;
        item.coolDownTimer--;
    }
    
    [clock setString:[NSString stringWithFormat:@"Time:%d", 
                      (levelTime - gameTime)]];
    if(!parentScene.isGamePaused){
        gameTime++;
    }
    if (gameTime >= levelTime) {
        [parentScene checkBattleResult];
    }
    
}

-(void) generateEnemy: (ccTime)dt {
    
    NSMutableArray *spawnedObjects = [NSMutableArray array];
    //BattleScene *parentScene = (BattleScene*)[self parent];
    //NSInteger secondsElapsed = [parentScene getClockTimeSeconds];
    
    for(GameObject* gameObj in gameObjectsWaitingToSpawn)
    {
        //if(secondsElapsed > [[gameObj time] integerValue])
        if(gameTime > [[gameObj time] integerValue])
        {
            
            if ([[gameObj type] integerValue] == kCoinObject) {
                // Do Generate coin
                gameObj.scale = 0.5f;   
                [self addObjectToLane:[[gameObj path] integerValue]
                        andWithObject:gameObj];
                [spawnedObjects addObject:gameObj];
            } else if ( [[gameObj type] integerValue] >= kPowerupHP) {
                // Powerup numbers are 40 and above
            } else { // Else it is a unit
                NSInteger pathToAddObjectTo = [[gameObj path] integerValue];
                [self addEnemyToLane:pathToAddObjectTo 
                         andWithUnit:gameObj]; 
                [spawnedObjects addObject:gameObj];
            }  
        }
    }
    
    [[self gameObjectsWaitingToSpawn] removeObjectsInArray:spawnedObjects];
}

-(void) generateCoin {
    for (int i=3; i<levelTime; i=i+4) {
        Coin *coin = [[Coin alloc] initWithRandomPositionWithTime:i ];
        coin.scale = 0.5f;
        [gameObjectsWaitingToSpawn addObject:coin];
    }
}

-(void) dealloc{
    
    [gameObjectsWaitingToSpawn release];
        
    [_playerUnits release];
    _playerUnits = nil;
    [_enemyUnits release];
    _enemyUnits = nil;
    [_catUnits release];
    _catUnits = nil;
    [_dogUnits release];
    _dogUnits = nil;
    [_enemy release];
    _enemy = nil;
    [_walkAction release];
    _walkAction = nil;
    [_moveAction release];
    _moveAction = nil;
    [_selectableUnits release];
    _selectableUnits = nil;
    [_selSprite release];
    _selSprite = nil;
    
    //Reference on its function
    //http://www.cocos2d-iphone.org/api-ref/0.99.5/interface_c_c_sprite_frame_cache.html
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames]; 
    
    [super dealloc];
}

@end
