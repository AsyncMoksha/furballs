//
//  Pisit.m
//  Unit class with Procedural animation based on Sprites assigned as a part
//  
//  Example Usage:
//  CGSize size = [[CCDirector sharedDirector] winSize];
//  pisit = [[Unit_Type2 alloc] initWithClassName:@"cat1Class" andFlipX:YES];
//  pisit.position = ccp(0+15, size.height/2); <-- Has to assign a position yourself
//
//  "cat1Class" indicate a plist of unit data not an unit atlas plist
//  Note: Unit has no self remove command and need to be modify in 
//        updateStateWithDeltaTime with "DEAD" UNIT STATE 
//        then remove HelloWorldLayer.h
//
//  Created by Pisit Praiwattana on 10/4/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "Unit_Type2.h"
@implementation Unit_Type2
@synthesize headPart;
@synthesize facePart;
@synthesize bodyPart;
@synthesize tailPart;
@synthesize fLeg_LPart;
@synthesize bLeg_LPart;
@synthesize fLeg_RPart;
@synthesize bLeg_RPart;
@synthesize state;
@synthesize speed;
@synthesize attackSpeed;
@synthesize isBattleStance;
@synthesize isFlipX;
@synthesize unitClassName;
@synthesize faceNormalFileName;
@synthesize faceAttackFileName;
@synthesize faceCryFileName;

-(id) init{
    if(self = [super init]){
        self.state = IDLE;
        self.speed = 5;
        self.attackSpeed = 5;
        self.isBattleStance = FALSE;
        self.isFlipX = FALSE;
    }
    return self;
}

-(id) initWithClassName:(NSString*)className andFlipX:(BOOL)flipBoolean{
    if(self = [super init]){
        self.unitClassName = className;
        self.state = IDLE;
        //Default base animation speed to 5 for speed and attackSpeed. 
        //By Formula AnimationFactor = 1*5/speed
        self.speed = 10;
        self.attackSpeed = 10;
        self.isBattleStance = FALSE;
        self.isFlipX = flipBoolean;
        
        [self initBodySprite];
        [self adjustAnchorPoint];
        [self constructBody];
    }
    return self;
}

-(void) initBodySprite{
    [self setHeadPart: [self loadPlistForSpriteWithName:@"head" andClassName:unitClassName]];
    [self setFacePart: [self loadPlistForSpriteWithName:@"face" andClassName:unitClassName]];
    [self setBodyPart: [self loadPlistForSpriteWithName:@"body" andClassName:unitClassName]];
    [self setFLeg_LPart: [self loadPlistForSpriteWithName:@"frontLeg_Left" andClassName:unitClassName]];
    [self setBLeg_LPart: [self loadPlistForSpriteWithName:@"backLeg_Left" andClassName:unitClassName]];
    [self setFLeg_RPart: [self loadPlistForSpriteWithName:@"frontLeg_Right" andClassName:unitClassName]];
    [self setBLeg_RPart: [self loadPlistForSpriteWithName:@"backLeg_Right" andClassName:unitClassName]];
    [self setTailPart: [self loadPlistForSpriteWithName:@"tail" andClassName:unitClassName]];
}

-(void) adjustAnchorPoint{
    //adjust appropriate anchorPoint of Leg and tail parts
    self.fLeg_LPart.anchorPoint = ccp(0.5,1);
    self.bLeg_LPart.anchorPoint = ccp(0.5,1);
    self.fLeg_RPart.anchorPoint = ccp(0.5,1);
    self.bLeg_RPart.anchorPoint = ccp(0.5,1);
    if(self.isFlipX){
        self.tailPart.anchorPoint = ccp(1,0.5);
    }else{
        self.tailPart.anchorPoint = ccp(0,0.5);
    }

}

-(void) constructBody{
    CCLOG(@"Constructing Process Begin ===============>");
    if(self.headPart){
        CCLOG(@"( '-' ) Assemble Pisit Parts !");
        [self addChild:headPart z:7 tag:HEADPART];
    }
    
    if(self.facePart){
        CCLOG(@"( ,,= .. =,, ) Paint face  !");
        [self addChild:facePart z:8 tag:FACEPART];
    }
    if(self.fLeg_LPart){
        CCLOG(@"('[]' *)o Assemble Front Leg on Left side !");
        [self addChild:fLeg_LPart z:6 tag:FLEG_LPART];
    }
    if(self.bLeg_LPart){
        CCLOG(@"('[]' *)o Assemble Back Leg on Left side !");
        [self addChild:bLeg_LPart z:5 tag:BLEG_LPART];
    }
    if(self.bodyPart){
        CCLOG(@"((>  w   <)) Assemble body !");
        [self addChild:bodyPart z:4 tag:BODYPART];
    }
    if(self.tailPart){
        CCLOG(@"(=,,= )-o  Assemble Tail part !!! ");
        [self addChild:tailPart z:3 tag:TAILPART];
    }
    if(self.fLeg_RPart){
        CCLOG(@"o(* '[]') Assemble Front Leg on right side!");
        [self addChild:fLeg_RPart z:2 tag:FLEG_RPART];
    }
    if(self.bLeg_RPart){
        CCLOG(@"o(* '[]') Assemble Back Leg on right side!");
        [self addChild:bLeg_RPart z:1 tag:BLEG_RPART];
    }
    
    CCLOG(@"Constructing Process End ( * w * )9 ===============> Ready");
}

-(void)stopAllActions{
    //Override Method to stop all actions of self and child nodes
    [super stopAllActions];
    [headPart stopAllActions];
    [bodyPart stopAllActions];
    [fLeg_LPart stopAllActions];
    [bLeg_LPart stopAllActions];
    [fLeg_RPart stopAllActions];
    [bLeg_RPart stopAllActions];
    [tailPart stopAllActions];
}

-(BOOL)isAllPartsStopMoving{
    //Check whether all parts (doesn't include self) running action is equal to 0 or not
    return (headPart.numberOfRunningActions == 0 
            && bodyPart.numberOfRunningActions == 0
            && fLeg_LPart.numberOfRunningActions ==0
            && bLeg_LPart.numberOfRunningActions == 0 
            && fLeg_RPart.numberOfRunningActions == 0
            && bLeg_RPart.numberOfRunningActions ==0
            && tailPart.numberOfRunningActions == 0);
}

-(void) animateWalk{
    float direction = 1;
    if(self.isFlipX){
        direction = -1;
    }
    float animFactor = 1*kBaseAnimationMoveSpeed/self.speed;;
    //Create Actions
    CCAction *walkHeadMove = 
     [CCSequence actions:
      [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction],
      [CCRotateBy actionWithDuration:0.4*animFactor angle:-10*direction],
      [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction], nil];
    
    CCAction *walkFaceMove = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:-10*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:5*direction], nil];
    
    CCAction *walkFLeg_LAnim = 
     [CCSequence actions:
      [CCRotateBy actionWithDuration:0.2*animFactor angle:10*direction],
      [CCRotateBy actionWithDuration:0.4*animFactor angle:-20*direction],
      [CCRotateBy actionWithDuration:0.2*animFactor angle:10*direction], nil];
    
    CCAction *walkBLeg_LAnim = 
     [CCSequence actions:
      [CCRotateBy actionWithDuration:0.2*animFactor angle:-15*direction],
      [CCRotateBy actionWithDuration:0.4*animFactor angle:30*direction],
      [CCRotateBy actionWithDuration:0.2*animFactor angle:-15*direction] , nil];
    
    CCAction *walkFLeg_RAnim = 
                            [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-10*direction],
     [CCRotateBy actionWithDuration:0.4*animFactor angle:20*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-10*direction], nil];
    
    CCAction *walkBLeg_RAnim = 
     [CCSequence actions:
      [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
      [CCRotateBy actionWithDuration:0.4*animFactor angle:-30*direction],
      [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    CCAction *walkTailAnim = 
     [CCSequence actions:
      [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
      [CCRotateBy actionWithDuration:0.4*animFactor angle:-30*direction],
      [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    //Assign TAGS
    walkHeadMove.tag = WALKHEAD;
    walkFaceMove.tag = WALKFACE;
    walkFLeg_LAnim.tag = WALKFLEG_L;
    walkBLeg_LAnim.tag = WALKBLEG_L;
    walkFLeg_RAnim.tag = WALKFLEG_R;
    walkBLeg_RAnim.tag = WALKBLEG_R;
    walkTailAnim.tag = WALKTAIL;
    
    //Run action
    [headPart runAction:walkHeadMove];
    [facePart runAction:walkFaceMove];
    [fLeg_LPart runAction:walkFLeg_LAnim];
    [bLeg_LPart runAction:walkBLeg_LAnim];
    [fLeg_RPart runAction:walkFLeg_RAnim];
    [bLeg_RPart runAction:walkBLeg_RAnim];
    [tailPart runAction:walkTailAnim];
}

-(void) animateBattle{
    float direction = 1;
    if(self.isFlipX){
        direction = -1;
    }
    float animFactor = 1*kBaseAnimationAtkSpeed/self.attackSpeed;
    CCAction *battleHeadAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    CCAction *battleFaceAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-30*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:15*direction] , nil];
    
    CCAction *battleFLeg_LdAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.3*animFactor angle:120*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-150*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:30*direction] , nil];
    
    CCAction *battleFLeg_RdAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.4*animFactor angle:120*direction],
     [CCRotateBy actionWithDuration:0.2*animFactor angle:-150*direction],
     [CCRotateBy actionWithDuration:0.3*animFactor angle:30*direction] , nil];
    
    [headPart runAction:battleHeadAnim];
    [facePart runAction:battleFaceAnim];
    [fLeg_LPart runAction:battleFLeg_LdAnim];
    [fLeg_RPart runAction:battleFLeg_RdAnim];
}

-(void) setFaceTexture:(UNIT_STATE) newState{
    
    CCTexture2D *newTex = nil;
    NSString *faceName = nil;

    if(newState == IDLE){
        faceName = faceNormalFileName;
    }else if(newState == BATTLE){
        faceName = faceAttackFileName;
    }else if(newState == CRY){
        faceName = faceCryFileName;
    }
    if(faceName){
        CCSpriteFrame *tmpFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:faceName];
        newTex = [tmpFrame texture];
        if(newTex){
            CGRect rect = CGRectZero;
            rect = tmpFrame.rect;
            [facePart setTexture:newTex];
            [facePart setTextureRect:rect];
        }
    }
}

-(void) setBattleStance{
    if(!isBattleStance){
        float direction = 1;
        if(self.isFlipX){
            direction = -1;
        }
        
        //Change face to Attack
        [self setFaceTexture:BATTLE];
        CCAction *battleStance = [CCRotateBy actionWithDuration:0.3 angle:10*direction];
        CCAction *battlebLeg_LStance = [CCRotateBy actionWithDuration:0.3 angle:-10*direction];
        CCAction *battlebLeg_RStance = [CCRotateBy actionWithDuration:0.3 angle:-10*direction];
        
        [bLeg_LPart runAction:battlebLeg_LStance];
        [bLeg_RPart runAction:battlebLeg_RStance];
        [self runAction:battleStance];
        
        self.isBattleStance = TRUE;
    }  
}

-(void) setNormalStance{
    if(isBattleStance){
        float direction = 1;
        if(self.isFlipX){
            direction = -1;
        }
        
        //Change face to Normal
        [self setFaceTexture:IDLE];
        CCAction *normalStance = [CCRotateBy actionWithDuration:0.3 angle:-10*direction];
        CCAction *normalBLeg_LStance = [CCRotateBy actionWithDuration:0.3 angle:10*direction];
        CCAction *normalBLeg_RStance = [CCRotateBy actionWithDuration:0.3 angle:10*direction];
    
        [bLeg_LPart runAction:normalBLeg_LStance];
        [bLeg_RPart runAction:normalBLeg_RStance];
        [self runAction: normalStance];
        self.isBattleStance = FALSE;
    }
}

-(void) animateCry{
    
    float scaleFactor =  3;
    CCAction *cryHeadAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*scaleFactor angle:15],
     [CCRotateBy actionWithDuration:0.3*scaleFactor angle:-30], nil];
    
    CCAction *cryFaceAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*scaleFactor angle:15],
     [CCRotateBy actionWithDuration:0.3*scaleFactor angle:-30], nil];
    
    CCAction *cryTailAnim = 
    [CCSequence actions:
     [CCRotateBy actionWithDuration:0.2*scaleFactor angle:15],
     [CCRotateBy actionWithDuration:0.3*scaleFactor angle:-30], nil];
    
    [headPart runAction:cryHeadAnim];
    [facePart runAction:cryFaceAnim];
    [tailPart runAction:cryTailAnim];
    
    
}

-(void) doMoveAction{
    CCLOG(@"Called doMoveAction");
    CGPoint destination;
    float moveDuration = 0.0f;
    CCAction *moveAction = nil;
    if(!self.isFlipX){
        //Move Right - > Left
        destination = ccp(-20, self.position.y);
        moveDuration = (self.position.x)/(self.speed * 10.0);
    }else{
        //Move Left to Right
        CGSize size = [[CCDirector sharedDirector] winSize];
        destination = ccp(size.width+20,self.position.y);
        moveDuration = (size.width - self.position.x)/(self.speed * 10.0);
    }
    moveAction = [CCMoveTo actionWithDuration:moveDuration 
                                     position:destination];
    if(moveAction){
        [moveAction setTag:MOVEACTION];
        [self runAction:moveAction];
    }else{
        CCLOG(@"Error, no move action was generated");
    }
}

-(void) doFadeOut{
    //http://www.adamtong.co.uk/index.php/cocos2d/cocos2d-snippets-01-fading-a-cclayer/
    //Snippet to add fade to CCNode without SIGBERT !!!
    
    
    //Temporary Manually Apply
    CCAction *headOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *faceOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *bodyOut = [CCFadeOut actionWithDuration:1.8f];
    CCAction *fLeg_LOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *bLeg_LOut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *fLeg_ROut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *bLeg_ROut = [CCFadeOut actionWithDuration:2.0f];
    CCAction *tailOut = [CCFadeOut actionWithDuration:2.0f];
    
    [headPart runAction:headOut];
    [facePart runAction:faceOut];
    [bodyPart runAction:bodyOut];
    [fLeg_LPart runAction:fLeg_LOut];
    [bLeg_LPart runAction:bLeg_LOut];
    [fLeg_RPart runAction:fLeg_ROut];
    [bLeg_RPart runAction:bLeg_ROut];
    [tailPart runAction:tailOut];
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime{
    
    if (self.state == DEAD){
        if ([self numberOfRunningActions] == 0 && [self isAllPartsStopMoving]){
            //Unit is dead, remove
            //Calling Method in parent node to remove him T[]T"
            
            [self setVisible:NO];
            //HelloWorldLayer *parentNode = (HelloWorldLayer*)[self parent];
            //[parentNode pisitMoveEnded];
            //Require Method to remove from the parent HERE

            
        } 
        return; // Nothing to do if the unit is dead
    }

    if(self.state == BATTLE){
        if(self.numberOfRunningActions >0){
            //Still moving so stop move action
            [self stopActionByTag:MOVEACTION];
            return;
        }else if([self isAllPartsStopMoving]){
            //Move action is stopped and all parts are ready
            [self setBattleStance];
            [self animateBattle];
        }
    }

    if(self.state == WALK){
        if([self isAllPartsStopMoving]){
            //Continue animate walk if one cycle is ended
            [self animateWalk];
        }
    }
    
    if(self.state == IDLE){
        if(self.isBattleStance){
            //He is in battle stance, so change it back to normal
            [self setNormalStance];
        }else if(self.numberOfRunningActions == 0 
                 && [self isAllPartsStopMoving]){
            //Check self's action to ensure change on normal stance
            //Originally he will continue walking to goal
            [self setState:WALK];
            [self doMoveAction];
            
        }
    }

    if(self.state == CRY){
        if([self isAllPartsStopMoving]){
            if(self.isBattleStance){
                [self setNormalStance];
            }
            [self setFaceTexture:CRY];
            [self doFadeOut];
            [self setState:DEAD];
        }
    }
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    //If he reach end of scene on the left, he should be terminated !
    if ( self.position.x <= 0){
        [self setState:DEAD];
        [self stopAllActions];
        CCLOG(@"Goal -> Pisit is Dead (T_Ta)");
        return;
    }
    
    //If he reach end of scene on the right, he should be terminated !
    if ( self.position.x >= size.width){
        [self setState:DEAD];
        [self stopAllActions];
        CCLOG(@"Goal -> Pisit is Dead (T_Ta)");
        return;
    } 
}
    
/**
 * Return CCSprite associated with information saved in unitData plist
 * Doesn't include the pre-process of loading sprite into framecache.
 * @param spriteName : A name of sprite object to load from plist
 * @param className : A name of plist name to load
 * @return associated CCSpite, or nil if there is an error.
 * Note: This method will internally set some class variable for some
 * unique part. 
 * i.e. Face which require switchable texture
 * so faceAttackFileName, faceNormalFileName, faceCryFileName will be set
 */
-(CCSprite*)loadPlistForSpriteWithName:(NSString*)spriteName 
                          andClassName:(NSString*)className{
    
    CCSprite *spriteToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    //Get the path to plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:className ofType:@"plist"];
    }
    //Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    //Get just the mini-dictionary for this sprite based on spriteName
    NSDictionary *spriteSettings =
    [plistDictionary objectForKey:spriteName];
    if (spriteSettings == nil) {
        CCLOG(@"Could not locate SpriteWithName:%@",spriteName);
        return nil;
    }
    NSString *aSpriteName = [spriteSettings objectForKey:@"fileName"];
    float xPos = [[spriteSettings objectForKey:@"posX"] floatValue];
    float yPos = [[spriteSettings objectForKey:@"posY"] floatValue];
    CCLOG(@"Sprite name is %@",aSpriteName);
    //Be careful, assume sprite is already loaded in sprite frame
    spriteToReturn = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:aSpriteName]];
    
    //Default sprite is normal facing to the left direction
    float flipFactor = 1;
    if(self.isFlipX){
        //Since the unit is flip to face a right direction
        //Invert X position and flip inside sprite
        flipFactor = -1;    
        spriteToReturn.flipX = YES;
    }else{
        spriteToReturn.flipX = NO;
    }
    spriteToReturn.position = ccp(xPos*flipFactor, yPos);
    
    //For Specific clss name with load extra information
    if([spriteName isEqualToString:@"face"]){
        self.faceNormalFileName = [spriteSettings objectForKey:@"normalFileName"];
        self.faceAttackFileName = [spriteSettings objectForKey:@"attackFileName"];
        self.faceCryFileName    = [spriteSettings objectForKey:@"cryFileName"];
        
    }
    
    //Specific sprite has an extra property 
    return spriteToReturn;
}

-(void) dealloc{
    //Body Parts
    [headPart release];
    headPart = nil;
    [facePart release];
    facePart = nil;
    [bodyPart release];
    bodyPart = nil;
    [fLeg_LPart release];
    fLeg_LPart = nil;
    [bLeg_LPart release];
    bLeg_LPart = nil;
    [fLeg_RPart release];
    fLeg_RPart = nil;
    [bLeg_RPart release];
    bLeg_RPart = nil;
    [tailPart release];
    tailPart = nil;
    
    //String File name
    [unitClassName release];
    unitClassName = nil;
    [faceNormalFileName release];
    faceNormalFileName = nil;
    [faceAttackFileName release];
    faceAttackFileName = nil;
    [faceCryFileName release];
    faceCryFileName = nil;
    
    //Call it every time
    [super dealloc];
}
@end

