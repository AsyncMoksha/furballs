//
//  ConsoleLayer.m
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/11/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "ConsoleLayer.h"
#import "BattleScene.h"

@implementation ConsoleLayer

@synthesize unitNameLabel;
@synthesize hitPointLabel;
@synthesize attackLabel;
@synthesize attackSpeedLabel;
@synthesize speedLabel;
@synthesize spawnRateLabel;
@synthesize dogUnitNameLabel;
@synthesize dogHitPointLabel;
@synthesize dogAttackLabel;
@synthesize dogAttackSpeedLabel;
@synthesize dogSpeedLabel;
@synthesize dogSpawnRateLabel;
@synthesize unitIndex;
@synthesize catIndex;
@synthesize dogIndex;
@synthesize unitArray;
@synthesize catArray;
@synthesize dogArray;

- (id)init
{
    unitIndex = 0;
    catIndex = 0;
    dogIndex = 0;
    self = [super initWithColor:ccc4(255,255,255,128)];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //BattleScene *parentScene = (BattleScene *) [self parent];
        //NSMutableArray *unitArray = parentScene.selectableUnits;
        //Unit *unit = [unitArray objectAtIndex:unitIndex]; 
        
        unitNameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Name:"] fontName:@"Arial" fontSize:12.0];
        unitNameLabel.position = ccp(120, size.height-30);
        unitNameLabel.color = ccc3(0, 0, 0);
        
        hitPointLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP:"] fontName:@"Arial" fontSize:12.0];
        hitPointLabel.position = ccp(120, size.height-60);
        hitPointLabel.color = ccc3(0, 0, 0);
        
        attackLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"ATK:"] fontName:@"Arial" fontSize:12.0];
        attackLabel.position = ccp(120, size.height-90);
        attackLabel.color = ccc3(0, 0, 0);
        
        attackSpeedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"ATK SPD:"] fontName:@"Arial" fontSize:12.0];
        attackSpeedLabel.position = ccp(120, size.height-120);
        attackSpeedLabel.color = ccc3(0, 0, 0);
        
        speedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SPD:"] fontName:@"Arial" fontSize:12.0];
        speedLabel.position = ccp(120, size.height-150);
        speedLabel.color = ccc3(0, 0, 0);
        
        spawnRateLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"CD:"] fontName:@"Arial" fontSize:12.0];
        spawnRateLabel.position = ccp(120, size.height-180);
        spawnRateLabel.color = ccc3(0, 0, 0);
        
        //self.contentSize.height = size.height/2;
        //Buttons
        CCMenuItemImage *nextButton = [
                                          CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                          selectedImage:@"plus_button.png"  
                                          target:self 
                                          selector:@selector(nextClicked)
                                          ];
        nextButton.position = ccp(
                                  unitNameLabel.position.x + 70,
                                  size.height - 30
                                  );
        
        CCMenuItemImage *previousButton = [
                                           CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                           selectedImage:
                                           @"minus_button.png"  
                                           target:self 
                                           selector:
                                           @selector(previousClicked)
                                           ];
        previousButton.position = ccp(
                                  unitNameLabel.position.x - 70,
                                  size.height - 30
                                  );
        
        CCMenuItemImage *increaseHPButton = [
                                       CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                       selectedImage:@"plus_button.png"  
                                       target:self 
                                       selector:
                                             @selector(increaseHPClicked)
                                       ];
        increaseHPButton.position = ccp(
                                  hitPointLabel.position.x + 70,
                                  hitPointLabel.position.y
                                  );
        
        CCMenuItemImage *decreaseHPButton = [
                                           CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                           selectedImage:
                                           @"minus_button.png"  
                                           target:self 
                                           selector:
                                           @selector(decreaseHPClicked)
                                           ];
        decreaseHPButton.position = ccp(
                                      hitPointLabel.position.x - 70,
                                      hitPointLabel.position.y 
                                      );
        CCMenuItemImage *increaseATKButton = [
                                                 CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                                 selectedImage:@"plus_button.png"  
                                                 target:self 
                                                 selector:
                                              @selector(increaseATKClicked)
                                                 ];
        increaseATKButton.position = ccp(
                                            attackLabel.position.x + 70,
                                            attackLabel.position.y
                                            );
        
        CCMenuItemImage *decreaseATKButton = [
                                                 CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                                 selectedImage:
                                                 @"minus_button.png"  
                                                 target:self 
                                                 selector:
                                                 @selector(decreaseATKClicked)
                                                 ];
        decreaseATKButton.position = ccp(
                                            attackLabel.position.x - 70,
                                            attackLabel.position.y 
                                            );
        CCMenuItemImage *increaseATKSPDButton = [
                                              CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                              selectedImage:@"plus_button.png"  
                                              target:self 
                                              selector:@selector(increaseATKSPDClicked)
                                              ];
        increaseATKSPDButton.position = ccp(
                                         attackSpeedLabel.position.x + 70,
                                         attackSpeedLabel.position.y
                                         );
        
        CCMenuItemImage *decreaseATKSPDButton = [
                                              CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                              selectedImage:
                                              @"minus_button.png"  
                                              target:self 
                                              selector:
                                              @selector(decreaseATKSPDClicked)
                                              ];
        decreaseATKSPDButton.position = ccp(
                                         attackSpeedLabel.position.x - 70,
                                         attackSpeedLabel.position.y 
                                         );
        CCMenuItemImage *increaseSPDButton = [
                                                 CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                                 selectedImage:@"plus_button.png"  
                                                 target:self 
                                                 selector:@selector(increaseSPDClicked)
                                                 ];
        increaseSPDButton.position = ccp(
                                            speedLabel.position.x + 70,
                                            speedLabel.position.y
                                            );
        
        CCMenuItemImage *decreaseSPDButton = [
                                                 CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                                 selectedImage:
                                                 @"minus_button.png"  
                                                 target:self 
                                                 selector:
                                                 @selector(decreaseSPDClicked)
                                                 ];
        decreaseSPDButton.position = ccp(
                                            speedLabel.position.x - 70,
                                            speedLabel.position.y 
                                            );
        CCMenuItemImage *increaseCDButton = [
                                              CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                              selectedImage:@"plus_button.png"  
                                              target:self 
                                              selector:@selector(increaseCDClicked)
                                              ];
        increaseCDButton.position = ccp(
                                         spawnRateLabel.position.x + 70,
                                         spawnRateLabel.position.y
                                         );
        
        CCMenuItemImage *decreaseCDButton = [
                                              CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                              selectedImage:
                                              @"minus_button.png"  
                                              target:self 
                                              selector:
                                              @selector(decreaseCDClicked)
                                              ];
        decreaseCDButton.position = ccp(
                                         spawnRateLabel.position.x - 70,
                                         spawnRateLabel.position.y 
                                         );
        
        // Dog buttons saga
        dogUnitNameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Name:"] fontName:@"Arial" fontSize:12.0];
        dogUnitNameLabel.position = ccp(320, size.height-30);
        dogUnitNameLabel.color = ccc3(0, 0, 0);
        
        dogHitPointLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP:"] fontName:@"Arial" fontSize:12.0];
        dogHitPointLabel.position = ccp(320, size.height-60);
        dogHitPointLabel.color = ccc3(0, 0, 0);
        
        dogAttackLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"ATK:"] fontName:@"Arial" fontSize:12.0];
        dogAttackLabel.position = ccp(320, size.height-90);
        dogAttackLabel.color = ccc3(0, 0, 0);
        
        dogAttackSpeedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"ATK SPD:"] fontName:@"Arial" fontSize:12.0];
        dogAttackSpeedLabel.position = ccp(320, size.height-120);
        dogAttackSpeedLabel.color = ccc3(0, 0, 0);
        
        dogSpeedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SPD:"] fontName:@"Arial" fontSize:12.0];
        dogSpeedLabel.position = ccp(320, size.height-150);
        dogSpeedLabel.color = ccc3(0, 0, 0);
        
        dogSpawnRateLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"CD:"] fontName:@"Arial" fontSize:12.0];
        dogSpawnRateLabel.position = ccp(320, size.height-180);
        dogSpawnRateLabel.color = ccc3(0, 0, 0);
        
        //self.contentSize.height = size.height/2;
        //Buttons
        CCMenuItemImage *nextDogButton = [
                                       CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                       selectedImage:@"plus_button.png"  
                                       target:self 
                                       selector:@selector(nextDogClicked)
                                       ];
        nextDogButton.position = ccp(
                                  dogUnitNameLabel.position.x + 70,
                                  size.height - 30
                                  );
        
        CCMenuItemImage *previousDogButton = [
                                           CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                           selectedImage:
                                           @"minus_button.png"  
                                           target:self 
                                           selector:
                                           @selector(previousDogClicked)
                                           ];
        previousDogButton.position = ccp(
                                      dogUnitNameLabel.position.x - 70,
                                      size.height - 30
                                      );
        
        CCMenuItemImage *increaseDogHPButton = [
                                             CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                             selectedImage:@"plus_button.png"  
                                             target:self 
                                             selector:@selector(increaseDogHPClicked)
                                             ];
        increaseDogHPButton.position = ccp(
                                        dogHitPointLabel.position.x + 70,
                                        dogHitPointLabel.position.y
                                        );
        
        CCMenuItemImage *decreaseDogHPButton = [
                                             CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                             selectedImage:
                                             @"minus_button.png"  
                                             target:self 
                                             selector:
                                             @selector(decreaseDogHPClicked)
                                             ];
        decreaseDogHPButton.position = ccp(
                                        dogHitPointLabel.position.x - 70,
                                        dogHitPointLabel.position.y 
                                        );
        CCMenuItemImage *increaseDogATKButton = [
                                              CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                              selectedImage:@"plus_button.png"  
                                              target:self 
                                              selector:@selector(increaseDogATKClicked)
                                              ];
        increaseDogATKButton.position = ccp(
                                         dogAttackLabel.position.x + 70,
                                         dogAttackLabel.position.y
                                         );
        
        CCMenuItemImage *decreaseDogATKButton = [
                                              CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                              selectedImage:
                                              @"minus_button.png"  
                                              target:self 
                                              selector:
                                              @selector(decreaseDogATKClicked)
                                              ];
        decreaseDogATKButton.position = ccp(
                                         dogAttackLabel.position.x - 70,
                                         dogAttackLabel.position.y 
                                         );
        CCMenuItemImage *increaseDogATKSPDButton = [
                                                 CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                                 selectedImage:@"plus_button.png"  
                                                 target:self 
                                                 selector:@selector(increaseDogATKSPDClicked)
                                                 ];
        increaseDogATKSPDButton.position = ccp(
                                            dogAttackSpeedLabel.position.x
                                               + 70,
                                            dogAttackSpeedLabel.position.y
                                            );
        
        CCMenuItemImage *decreaseDogATKSPDButton = [
                                                 CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                                 selectedImage:
                                                 @"minus_button.png"  
                                                 target:self 
                                                 selector:
                                                 @selector(decreaseDogATKSPDClicked)
                                                 ];
        decreaseDogATKSPDButton.position = ccp(
                                            dogAttackSpeedLabel.position.x 
                                               - 70,
                                            dogAttackSpeedLabel.position.y 
                                            );
        CCMenuItemImage *increaseDogSPDButton = [
                                              CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                              selectedImage:@"plus_button.png"  
                                              target:self 
                                              selector:@selector(increaseDogSPDClicked)
                                              ];
        increaseDogSPDButton.position = ccp(
                                         dogSpeedLabel.position.x + 70,
                                         dogSpeedLabel.position.y
                                         );
        
        CCMenuItemImage *decreaseDogSPDButton = [
                                              CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                              selectedImage:
                                              @"minus_button.png"  
                                              target:self 
                                              selector:
                                              @selector(decreaseDogSPDClicked)
                                              ];
        decreaseDogSPDButton.position = ccp(
                                         dogSpeedLabel.position.x - 70,
                                         dogSpeedLabel.position.y 
                                         );
        CCMenuItemImage *increaseDogCDButton = [
                                             CCMenuItemImage itemFromNormalImage:@"plus_button.png" 
                                             selectedImage:@"plus_button.png"  
                                             target:self 
                                             selector:@selector(increaseDogCDClicked)
                                             ];
        increaseDogCDButton.position = ccp(
                                        dogSpawnRateLabel.position.x + 70,
                                        dogSpawnRateLabel.position.y
                                        );
        
        CCMenuItemImage *decreaseDogCDButton = [
                                             CCMenuItemImage itemFromNormalImage:@"minus_button.png" 
                                             selectedImage:
                                             @"minus_button.png"  
                                             target:self 
                                             selector:
                                             @selector(decreaseDogCDClicked)
                                             ];
        decreaseDogCDButton.position = ccp(
                                        dogSpawnRateLabel.position.x - 70,
                                        dogSpawnRateLabel.position.y 
                                        );
        
        // Reset Button
        CCMenuItemImage *resetButton = [
                                                CCMenuItemImage itemFromNormalImage:@"reset_button.png" 
                                                selectedImage:
                                                @"reset_button.png"  
                                                target:self 
                                                selector:
                                                @selector(resetClicked)
                                                ];
        resetButton.position = ccp(
                                           dogSpawnRateLabel.position.x - 40,
                                           dogSpawnRateLabel.position.y - 40 
                                           );
        
        // Reset Button
        CCMenuItemImage *saveButton = [
                                        CCMenuItemImage itemFromNormalImage:@"save_button.png" 
                                        selectedImage:
                                        @"save_button.png"  
                                        target:self 
                                        selector:
                                        @selector(saveClicked)
                                        ];
        saveButton.position = ccp(
                                   spawnRateLabel.position.x - 40,
                                   spawnRateLabel.position.y - 40 
                                   );
        
        
        CCMenu *mainMenu = [CCMenu menuWithItems:
                            nextButton,
                            previousButton,
                            increaseHPButton,
                            decreaseHPButton,
                            increaseATKButton,
                            decreaseATKButton,
                            increaseATKSPDButton,
                            decreaseATKSPDButton,
                            increaseSPDButton,
                            decreaseSPDButton,
                            increaseCDButton,
                            decreaseCDButton,
                            nextDogButton,
                            previousDogButton,
                            increaseDogHPButton,
                            decreaseDogHPButton,
                            increaseDogATKButton,
                            decreaseDogATKButton,
                            increaseDogATKSPDButton,
                            decreaseDogATKSPDButton,
                            increaseDogSPDButton,
                            decreaseDogSPDButton,
                            increaseDogCDButton,
                            decreaseDogCDButton,
                            resetButton,
                            saveButton,
                            nil];
        mainMenu.position = CGPointZero;
        [self addChild:mainMenu z:1];
        [self addChild:unitNameLabel];
        [self addChild:hitPointLabel];
        [self addChild:attackLabel];
        [self addChild:attackSpeedLabel];
        [self addChild:speedLabel];
        [self addChild:spawnRateLabel];
        [self addChild:dogUnitNameLabel];
        [self addChild:dogHitPointLabel];
        [self addChild:dogAttackLabel];
        [self addChild:dogAttackSpeedLabel];
        [self addChild:dogSpeedLabel];
        [self addChild:dogSpawnRateLabel];
    }
    
    return self;
}

-(void) openConsoleWithArray: (NSMutableArray *) array {
    //if (unitArray == nil) {
        unitArray = [[NSMutableArray alloc] initWithArray:array];
    //}
    
    NSMutableDictionary *unitDict = [unitArray objectAtIndex:unitIndex];
    [unitNameLabel setString: 
     [NSString stringWithFormat:@"Name: %@", 
      [[unitDict objectForKey:@"name"] description]]];
    [hitPointLabel setString: 
     [NSString stringWithFormat:@"HP: %d", 
      [[unitDict objectForKey:@"hitPoint"] intValue]]];
    [attackLabel setString: 
     [NSString stringWithFormat:@"ATK: %d", 
      [[unitDict objectForKey:@"attack"] intValue]]];
    [attackSpeedLabel setString: 
     [NSString stringWithFormat:@"ATK SPD: %d", 
      [[unitDict objectForKey:@"attackSpeed"] intValue]]];
    [speedLabel setString: 
     [NSString stringWithFormat:@"SPD: %d", 
      [[unitDict objectForKey:@"speed"] intValue]]];
    [spawnRateLabel setString: 
     [NSString stringWithFormat:@"CD: %d", 
      [[unitDict objectForKey:@"spawnRate"] intValue]]];
}

-(void) openConsoleWithArrays: (NSMutableArray *)catUnits
              andWithDogArray: (NSMutableArray *)dogUnits {
    //if (unitArray == nil) {
    //unitArray = [[NSMutableArray alloc] initWithArray:array];
    //}
    catArray = [[NSMutableArray alloc] initWithArray:catUnits];
    dogArray = [[NSMutableArray alloc] initWithArray:dogUnits];
    
    NSMutableDictionary *unitDict = [catArray objectAtIndex:unitIndex];
    [unitNameLabel setString: 
     [NSString stringWithFormat:@"Name: %@", 
      [[unitDict objectForKey:@"name"] description]]];
    [hitPointLabel setString: 
     [NSString stringWithFormat:@"HP: %d", 
      [[unitDict objectForKey:@"hitPoint"] intValue]]];
    [attackLabel setString: 
     [NSString stringWithFormat:@"ATK: %d", 
      [[unitDict objectForKey:@"attack"] intValue]]];
    [attackSpeedLabel setString: 
     [NSString stringWithFormat:@"ATK SPD: %d", 
      [[unitDict objectForKey:@"attackSpeed"] intValue]]];
    [speedLabel setString: 
     [NSString stringWithFormat:@"SPD: %d", 
      [[unitDict objectForKey:@"speed"] intValue]]];
    [spawnRateLabel setString: 
     [NSString stringWithFormat:@"CD: %d", 
      [[unitDict objectForKey:@"spawnRate"] intValue]]];
    
    NSMutableDictionary *dogDict = [dogArray objectAtIndex:unitIndex];
    [dogUnitNameLabel setString: 
     [NSString stringWithFormat:@"Name: %@", 
      [[dogDict objectForKey:@"name"] description]]];
    [dogHitPointLabel setString: 
     [NSString stringWithFormat:@"HP: %d", 
      [[dogDict objectForKey:@"hitPoint"] intValue]]];
    [dogAttackLabel setString: 
     [NSString stringWithFormat:@"ATK: %d", 
      [[dogDict objectForKey:@"attack"] intValue]]];
    [dogAttackSpeedLabel setString: 
     [NSString stringWithFormat:@"ATK SPD: %d", 
      [[dogDict objectForKey:@"attackSpeed"] intValue]]];
    [dogSpeedLabel setString: 
     [NSString stringWithFormat:@"SPD: %d", 
      [[dogDict objectForKey:@"speed"] intValue]]];
    [dogSpawnRateLabel setString: 
     [NSString stringWithFormat:@"CD: %d", 
      [[dogDict objectForKey:@"spawnRate"] intValue]]];
}



-(void) nextClicked{
    //CCLOG(@"Increased.");
    if (catArray != nil) {
        catIndex++;
        if (catIndex == [catArray count]) {
            catIndex = 0;
        }
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        [unitNameLabel setString: 
         [NSString stringWithFormat:@"Name: %@", 
          [[unitDict objectForKey:@"name"] description]]];
        [hitPointLabel setString: 
         [NSString stringWithFormat:@"HP: %d", 
          [[unitDict objectForKey:@"hitPoint"] intValue]]];
        [attackLabel setString: 
         [NSString stringWithFormat:@"ATK: %d", 
          [[unitDict objectForKey:@"attack"] intValue]]];
        [attackSpeedLabel setString: 
         [NSString stringWithFormat:@"ATK SPD: %d", 
          [[unitDict objectForKey:@"attackSpeed"] intValue]]];
        [speedLabel setString: 
         [NSString stringWithFormat:@"SPD: %d", 
          [[unitDict objectForKey:@"speed"] intValue]]];
        [spawnRateLabel setString: 
         [NSString stringWithFormat:@"CD: %d", 
          [[unitDict objectForKey:@"spawnRate"] intValue]]];
    }
}

-(void) previousClicked{

    //CCLOG(@"Decreased.");
    if (catArray != nil) {
        catIndex--;
        if (catIndex < 0) {
            catIndex = [catArray count] - 1;
        }
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        [unitNameLabel setString: 
         [NSString stringWithFormat:@"Name: %@", 
          [[unitDict objectForKey:@"name"] description]]];
        [hitPointLabel setString: 
         [NSString stringWithFormat:@"HP: %d", 
          [[unitDict objectForKey:@"hitPoint"] intValue]]];
        [attackLabel setString: 
         [NSString stringWithFormat:@"ATK: %d", 
          [[unitDict objectForKey:@"attack"] intValue]]];
        [attackSpeedLabel setString: 
         [NSString stringWithFormat:@"ATK SPD: %d", 
          [[unitDict objectForKey:@"attackSpeed"] intValue]]];
        [speedLabel setString: 
         [NSString stringWithFormat:@"SPD: %d", 
          [[unitDict objectForKey:@"speed"] intValue]]];
        [spawnRateLabel setString: 
         [NSString stringWithFormat:@"CD: %d", 
          [[unitDict objectForKey:@"spawnRate"] intValue]]];
    }
}

-(void) nextDogClicked{
    //CCLOG(@"Increased.");
    if (dogArray != nil) {
        dogIndex++;
        if (dogIndex == [dogArray count]) {
            dogIndex = 0;
        }
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        [dogUnitNameLabel setString: 
         [NSString stringWithFormat:@"Name: %@", 
          [[unitDict objectForKey:@"name"] description]]];
        [dogHitPointLabel setString: 
         [NSString stringWithFormat:@"HP: %d", 
          [[unitDict objectForKey:@"hitPoint"] intValue]]];
        [dogAttackLabel setString: 
         [NSString stringWithFormat:@"ATK: %d", 
          [[unitDict objectForKey:@"attack"] intValue]]];
        [dogAttackSpeedLabel setString: 
         [NSString stringWithFormat:@"ATK SPD: %d", 
          [[unitDict objectForKey:@"attackSpeed"] intValue]]];
        [dogSpeedLabel setString: 
         [NSString stringWithFormat:@"SPD: %d", 
          [[unitDict objectForKey:@"speed"] intValue]]];
        [dogSpawnRateLabel setString: 
         [NSString stringWithFormat:@"CD: %d", 
          [[unitDict objectForKey:@"spawnRate"] intValue]]];
    }
}

-(void) previousDogClicked{
    
    //CCLOG(@"Decreased.");
    if (dogArray != nil) {
        dogIndex--;
        if (dogIndex < 0) {
            dogIndex = [dogArray count] - 1;
        }
        
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        [dogUnitNameLabel setString: 
         [NSString stringWithFormat:@"Name: %@", 
          [[unitDict objectForKey:@"name"] description]]];
        [dogHitPointLabel setString: 
         [NSString stringWithFormat:@"HP: %d", 
          [[unitDict objectForKey:@"hitPoint"] intValue]]];
        [dogAttackLabel setString: 
         [NSString stringWithFormat:@"ATK: %d", 
          [[unitDict objectForKey:@"attack"] intValue]]];
        [dogAttackSpeedLabel setString: 
         [NSString stringWithFormat:@"ATK SPD: %d", 
          [[unitDict objectForKey:@"attackSpeed"] intValue]]];
        [dogSpeedLabel setString: 
         [NSString stringWithFormat:@"SPD: %d", 
          [[unitDict objectForKey:@"speed"] intValue]]];
        [dogSpawnRateLabel setString: 
         [NSString stringWithFormat:@"CD: %d", 
          [[unitDict objectForKey:@"spawnRate"] intValue]]];
    }
}

-(void) increaseHPClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int HP = [[unitDict objectForKey:@"hitPoint"] intValue];
        HP++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:HP]  
                    forKey:@"hitPoint"];
        [hitPointLabel setString: 
         [NSString stringWithFormat:@"HP: %d", HP]];
        
        //[unitDict release];
        //unitDict = nil;

    }
    
}

-(void) decreaseHPClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int HP = [[unitDict objectForKey:@"hitPoint"] intValue];
        HP--;
        if (HP != 1) {
            [unitDict setValue: [[NSNumber alloc] initWithInt:HP]  
                        forKey:@"hitPoint"];
            [hitPointLabel setString: 
             [NSString stringWithFormat:@"HP: %d", HP]];
            
            //[unitDict release];
            //unitDict = nil;

        }
        
    }
}
-(void) increaseATKClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int ATK = [[unitDict objectForKey:@"attack"] intValue];
        ATK++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:ATK]  
                    forKey:@"attack"];
        [attackLabel setString: 
         [NSString stringWithFormat:@"ATK: %d", ATK]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseATKClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int ATK = [[unitDict objectForKey:@"attack"] intValue];
        if( ATK != 1) {
            ATK--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:ATK]  
                        forKey:@"attack"];
            [attackLabel setString: 
             [NSString stringWithFormat:@"ATK: %d", ATK]];
            
            

        }
        //[unitDict release];
        //unitDict = nil;
        
    }
}
-(void) increaseATKSPDClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int ATKSPD = [[unitDict objectForKey:@"attackSpeed"] intValue];
        ATKSPD++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:ATKSPD]  
                    forKey:@"attackSpeed"];
        [attackSpeedLabel setString: 
         [NSString stringWithFormat:@"ATK SPD: %d", ATKSPD]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseATKSPDClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int ATKSPD = [[unitDict objectForKey:@"attackSpeed"] intValue];
        if( ATKSPD != 1) {
            ATKSPD--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:ATKSPD]  
                        forKey:@"attackSpeed"];
            [attackSpeedLabel setString: 
             [NSString stringWithFormat:@"ATK SPD: %d", ATKSPD]];
            
            //[unitDict release];
            //unitDict = nil;

        }
    }
}
-(void) increaseSPDClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int SPD = [[unitDict objectForKey:@"speed"] intValue];
        SPD++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:SPD]  
                    forKey:@"speed"];
        [speedLabel setString: 
         [NSString stringWithFormat:@"SPD: %d", SPD]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseSPDClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int SPD = [[unitDict objectForKey:@"speed"] intValue];
        if (SPD != 1) {
            SPD--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:SPD]  
                        forKey:@"speed"];
            [speedLabel setString: 
             [NSString stringWithFormat:@"SPD: %d", SPD]];
            
            //[unitDict release];
            //unitDict = nil;

        }
        
    }
}
-(void) increaseCDClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int CD = [[unitDict objectForKey:@"spawnRate"] intValue];
        CD++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:CD]  
                    forKey:@"spawnRate"];
        [spawnRateLabel setString: 
         [NSString stringWithFormat:@"CD: %d", CD]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseCDClicked {
    if (catArray != nil) {
        NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
        int CD = [[unitDict objectForKey:@"spawnRate"] intValue];
        if (CD != 1) {
            CD--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:CD]  
                        forKey:@"spawnRate"];
            [spawnRateLabel setString: 
             [NSString stringWithFormat:@"CD: %d", CD]];
            
            //[unitDict release];
            //unitDict = nil;

        }
    }
}

-(void) increaseDogHPClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int HP = [[unitDict objectForKey:@"hitPoint"] intValue];
        HP++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:HP]  
                    forKey:@"hitPoint"];
        [dogHitPointLabel setString: 
         [NSString stringWithFormat:@"HP: %d", HP]];
        
        //[unitDict release];
        //unitDict = nil;

    }
    
}

-(void) decreaseDogHPClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int HP = [[unitDict objectForKey:@"hitPoint"] intValue];
        HP--;
        if (HP != 1) {
            [unitDict setValue: [[NSNumber alloc] initWithInt:HP]  
                        forKey:@"hitPoint"];
            [dogHitPointLabel setString: 
             [NSString stringWithFormat:@"HP: %d", HP]];
            
            //[unitDict release];
            //unitDict = nil;

        }
        
    }
}
-(void) increaseDogATKClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int ATK = [[unitDict objectForKey:@"attack"] intValue];
        ATK++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:ATK]  
                    forKey:@"attack"];
        [dogAttackLabel setString: 
         [NSString stringWithFormat:@"ATK: %d", ATK]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseDogATKClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int ATK = [[unitDict objectForKey:@"attack"] intValue];
        if( ATK != 1) {
            ATK--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:ATK]  
                        forKey:@"attack"];
            [dogAttackLabel setString: 
             [NSString stringWithFormat:@"ATK: %d", ATK]];
            
            //[unitDict release];
            //unitDict = nil;

        }
        
    }
}
-(void) increaseDogATKSPDClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int ATKSPD = [[unitDict objectForKey:@"attackSpeed"] intValue];
        ATKSPD++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:ATKSPD]  
                    forKey:@"attackSpeed"];
        [dogAttackSpeedLabel setString: 
         [NSString stringWithFormat:@"ATK SPD: %d", ATKSPD]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseDogATKSPDClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int ATKSPD = [[unitDict objectForKey:@"attackSpeed"] intValue];
        if( ATKSPD != 1) {
            ATKSPD--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:ATKSPD]  
                        forKey:@"attackSpeed"];
            [dogAttackSpeedLabel setString: 
             [NSString stringWithFormat:@"ATK SPD: %d", ATKSPD]];
            
            //[unitDict release];
            //unitDict = nil;

        }
    }
}
-(void) increaseDogSPDClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int SPD = [[unitDict objectForKey:@"speed"] intValue];
        SPD++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:SPD]  
                    forKey:@"speed"];
        [dogSpeedLabel setString: 
         [NSString stringWithFormat:@"SPD: %d", SPD]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseDogSPDClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int SPD = [[unitDict objectForKey:@"speed"] intValue];
        if (SPD != 1) {
            SPD--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:SPD]  
                        forKey:@"speed"];
            [dogSpeedLabel setString: 
             [NSString stringWithFormat:@"SPD: %d", SPD]];
            
            //[unitDict release];
            //unitDict = nil;

        }
        
    }
}
-(void) increaseDogCDClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:dogIndex];
        int CD = [[unitDict objectForKey:@"spawnRate"] intValue];
        CD++;
        [unitDict setValue: [[NSNumber alloc] initWithInt:CD]  
                    forKey:@"spawnRate"];
        [dogSpawnRateLabel setString: 
         [NSString stringWithFormat:@"CD: %d", CD]];
        
        //[unitDict release];
        //unitDict = nil;

    }
}
-(void) decreaseDogCDClicked {
    if (dogArray != nil) {
        NSMutableDictionary *unitDict = [dogArray objectAtIndex:catIndex];
        int CD = [[unitDict objectForKey:@"spawnRate"] intValue];
        if (CD != 1) {
            CD--;
            [unitDict setValue: [[NSNumber alloc] initWithInt:CD]  
                        forKey:@"spawnRate"];
            [dogSpawnRateLabel setString: 
             [NSString stringWithFormat:@"CD: %d", CD]];
        }
        
        //[unitDict release];
        //unitDict = nil;

    }
}

-(void) resetClicked {
    //NSError *error;
    // Reloading from file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *catPath = [documentsDirectory 
                         stringByAppendingPathComponent:@"catUnit.plist"]; //3
    NSString *dogPath = [documentsDirectory 
                         stringByAppendingPathComponent:@"dogUnit.plist"];
    // catUnit.plist in document folder
    NSMutableDictionary* catDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: catPath];
    catArray = [[NSMutableArray alloc] initWithArray:[catDictionary objectForKey:@"Unit"]];
    
    // dogUnit.plist in document folder
    NSMutableDictionary* dogDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: dogPath];
    dogArray = [[NSMutableArray alloc] initWithArray:[dogDictionary objectForKey:@"Unit"]];
    
    //Update changes immediately
    NSMutableDictionary *unitDict = [catArray objectAtIndex:catIndex];
    [unitNameLabel setString: 
     [NSString stringWithFormat:@"Name: %@", 
      [[unitDict objectForKey:@"name"] description]]];
    [hitPointLabel setString: 
     [NSString stringWithFormat:@"HP: %d", 
      [[unitDict objectForKey:@"hitPoint"] intValue]]];
    [attackLabel setString: 
     [NSString stringWithFormat:@"ATK: %d", 
      [[unitDict objectForKey:@"attack"] intValue]]];
    [attackSpeedLabel setString: 
     [NSString stringWithFormat:@"ATK SPD: %d", 
      [[unitDict objectForKey:@"attackSpeed"] intValue]]];
    [speedLabel setString: 
     [NSString stringWithFormat:@"SPD: %d", 
      [[unitDict objectForKey:@"speed"] intValue]]];
    [spawnRateLabel setString: 
     [NSString stringWithFormat:@"CD: %d", 
      [[unitDict objectForKey:@"spawnRate"] intValue]]];
    unitDict = [dogArray objectAtIndex:dogIndex];
    [dogUnitNameLabel setString: 
     [NSString stringWithFormat:@"Name: %@", 
      [[unitDict objectForKey:@"name"] description]]];
    [dogHitPointLabel setString: 
     [NSString stringWithFormat:@"HP: %d", 
      [[unitDict objectForKey:@"hitPoint"] intValue]]];
    [dogAttackLabel setString: 
     [NSString stringWithFormat:@"ATK: %d", 
      [[unitDict objectForKey:@"attack"] intValue]]];
    [dogAttackSpeedLabel setString: 
     [NSString stringWithFormat:@"ATK SPD: %d", 
      [[unitDict objectForKey:@"attackSpeed"] intValue]]];
    [dogSpeedLabel setString: 
     [NSString stringWithFormat:@"SPD: %d", 
      [[unitDict objectForKey:@"speed"] intValue]]];
    [dogSpawnRateLabel setString: 
     [NSString stringWithFormat:@"CD: %d", 
      [[unitDict objectForKey:@"spawnRate"] intValue]]];
    [unitDict release];
    unitDict = nil;
    //[paths release];
    [dogDictionary release];
    [catDictionary release];
}

-(void) saveClicked {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *catPath = [documentsDirectory 
                         stringByAppendingPathComponent:@"catUnit.plist"]; //3
    NSString *dogPath = [documentsDirectory 
                         stringByAppendingPathComponent:@"dogUnit.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: catPath]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"catUnit"ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: catPath error:&error]; //6
    }
    if (![fileManager fileExistsAtPath: dogPath]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"dogUnit"ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: dogPath error:&error]; //6
    }
    NSMutableDictionary *catData = [[NSMutableDictionary alloc] initWithContentsOfFile: catPath];
    NSMutableDictionary *dogData = [[NSMutableDictionary alloc] initWithContentsOfFile: dogPath];
    
    //here add elements to data file and write data to file
    
    [catData setObject:catArray forKey:@"Unit"];
    [catData writeToFile: catPath atomically:YES];
    
    [dogData setObject:dogArray forKey:@"Unit"];
    [dogData writeToFile: dogPath atomically:YES];
    
    CCLOG(@"Plist file saved! ");
    CCLOG(@"DO NOT FORGET TO UPDATE CURRENT PLIST FILE IN RESOURCE FOLDER");
    CCLOG(@"The new cat plist file is in %@", catPath);
    CCLOG(@"The new dog plist file is in %@", dogPath);
    [catData release];
    [dogData release];
    //[catPath release];
    //[dogPath release];
    
    
}

-(void) dealloc {
    [unitArray release];
    unitArray = nil;
    [unitNameLabel release];
    unitNameLabel = nil;
    [hitPointLabel release];
    hitPointLabel = nil;
    [attackLabel release];
    attackLabel = nil;
    [attackSpeedLabel release];
    attackSpeedLabel = nil;
    [speedLabel release];
    speedLabel = nil;
    [spawnRateLabel release];
    spawnRateLabel = nil;
    //[super dealloc];
}

@end
