//
//  DialogLayer.m
//  PAWS
// 
//  Example of how to initialize class
//  [[DialogLayer alloc] initWithBMFont:@"AppleLiGothic_Black18.fnt" andDialog:@"dialog1"];
//
//  Example of how to open dialog
//  [_dialogLayer openStoryDialog]
//
//  Example of how to close dialog
//  [_dialogLayer closeStoryDialog]
//
//  Created by Pisit Praiwattana on 10/25/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import "DialogLayer.h"

//Dialogue Layer
@implementation DialogLayer
@synthesize fontFileName = _fontFileName;
@synthesize speakerFileName = _speakerFileName;
@synthesize panelFileName = _panelFileName;
@synthesize msg = _msg;
@synthesize textLabel = _textLabel;
@synthesize dialogPanel = _dialogPanel;
@synthesize speaker = _speaker;
@synthesize currentIndex = _currentIndex;
@synthesize isDialogOpened = _isDialogOpened;

-(id) initWithBMFont:(NSString *)fontFileName andDialog: (NSString*)dialogFileName{
    self = [super init];
    if(self){
        //Initialization code here.
        _currentIndex = 0;
        _fontFileName = fontFileName;
        _textLabel = nil;
        _isDialogOpened = false;
        
        [self loadPlistForMessageDialog:dialogFileName];
        
        //CCLOG(@"We have %d item in msg",[_msg count]);
        //CCLOG(@"Original %@",(NSString*)[_msg objectAtIndex:0]);
        //CCLOG(@"Modified %@",[self cleanSyntaxString:[_msg objectAtIndex:0]]);
        
        //CCLOG(@"speaker file is %@",_speakerFileName);
        //CCLOG(@"panel file is %@",_panelFileName);
        
        CGSize size = [[CCDirector sharedDirector] winSize];  
        _dialogPanel = [CCSprite spriteWithFile:_panelFileName];
        _dialogPanel.position = ccp(size.width/2,size.height/2 - 70);
        [_dialogPanel setVisible:false];
        [_dialogPanel setScaleX:1.4f];
        [_dialogPanel setScaleY:0.5f];
        [self addChild:_dialogPanel z:2];
        
        
        _speaker = [CCSprite spriteWithFile:_speakerFileName];
        _speaker.position = ccp(size.width/2,size.height/2 + 60);
        [_speaker setVisible:false];
        [_speaker setScale:0.5f];
        [self addChild:_speaker z:1];
        
        //Enable touch
        self.isTouchEnabled = true; 
    }
    return self;
}

-(void) animateSpeakerIn{
    CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:0.4f scale:1.0f];
    [_speaker runAction:[CCSequence actions: scaleUp ,nil]];
    [_speaker setVisible:true];
}

-(void) animateDialogIn{
    CCFadeIn *fadeInPanel = [CCFadeIn actionWithDuration:0.2f];
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.2f position:ccp(0,15)];
    [_dialogPanel runAction:[CCSequence actions:fadeInPanel, moveUp, nil]];
    [_dialogPanel setVisible:true];
}

-(void) openStoryDialog{
    CCLOG(@"Open Story Dialog");
    if(!_isDialogOpened)
    {
        _currentIndex = 0;
        [self runAction:[CCSequence actions:
                         [CCCallFuncN actionWithTarget:self selector:@selector(animateSpeakerIn)],
                         [CCDelayTime actionWithDuration:0.4f],
                         [CCCallFuncN actionWithTarget:self selector:@selector(animateDialogIn)],
                         [CCDelayTime actionWithDuration:0.6f],
                         [CCCallFuncN actionWithTarget:self selector:@selector(displayMessageAndPlusIndexBy1)],nil]];
        //Display a first message
        _isDialogOpened = true;
    }
}

-(void) closeStoryDialog{
    CCLOG(@"Close Story Dialog");
    [_dialogPanel setVisible:false];
    [_speaker setVisible:false];
    
    [_speaker setScale:0.5f];
    [_dialogPanel setPosition:ccp(_dialogPanel.position.x, _dialogPanel.position.y - 15)];
    
    _isDialogOpened = false;
}

-(void) displayMessageAndPlusIndexBy1{
    [self removeChildByTag:DIALOG_LABEL_TAG cleanup:YES]; 
    if(_msg && [_msg count] > 0){
        // With CCLabelBMFont
        CGSize size = [[CCDirector sharedDirector] winSize];  
        if(_currentIndex < [_msg count]){
            CCLOG(@"Display index %d",_currentIndex);
            CCLabelBMFont *newLabel = nil;
            newLabel= [self labelFromString: [self cleanSyntaxString:[_msg objectAtIndex:_currentIndex]]];
            newLabel.position = ccp(size.width/2 - 200,size.height/2 - 5);
            [self addChild: newLabel z:3 tag: DIALOG_LABEL_TAG];
            _currentIndex++;
        }else{
            //CCLOG(@"End of Message");
            [self closeStoryDialog];
        }
        
    }
}

-(CCLabelBMFont*) labelFromString:(NSString*) myString{
    CCLabelBMFont *myLabel = nil;
    myLabel = [CCLabelBMFont labelWithString: myString 
                                     fntFile:_fontFileName];
    [myLabel setAnchorPoint:ccp(0,1)];
    return myLabel;
}

-(void) registerWithTouchDispatcher
{
    //Override to register this CCLayer to globalTouch Dispatcher
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

/**
 *  ccTouchBegan
 *  Keep track of touch at starting point.
 */
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    //Return true to claim this touch
    return TRUE;    
}
/**
 *  ccTouchEnded
 *  After player release his/her finger read next message
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(_isDialogOpened){
        [self displayMessageAndPlusIndexBy1];
    }
}

-(NSString*) cleanSyntaxString:(NSString*)originalString{
    originalString = [originalString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return originalString;
}
/**
 * Load dialog plist data and set speaker and msg class variable
 * return true if there is no error, flase otherwise
 */
-(BOOL)loadPlistForMessageDialog:(NSString*)dialogFileName
{
    CCLOG(@"Loading dialog %@",dialogFileName);
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",dialogFileName];
    NSString *plistPath;
    
    //Get the path to plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:dialogFileName ofType:@"plist"];
    }
    //Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    //If the plistArray was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", dialogFileName);
        return false; // No Plist Array or file found
    }
    
    //Get just the mini-dictionary for this sprite based on spriteName
    
    NSDictionary *dialogData =
    [plistDictionary objectForKey:@"dialog"];
    if (dialogData == nil) {
        CCLOG(@"Could not locate Dialog Dictionary.");
        return false;
    }
    _speakerFileName = [NSString stringWithFormat:[dialogData objectForKey:@"speakerName"]];
    _panelFileName = [NSString stringWithFormat:[dialogData objectForKey:@"panelName"]];
    _msg = [[NSArray alloc] initWithArray:[dialogData objectForKey:@"messages"]];
    
    return true;
}

-(void) dealloc{
    [_fontFileName release];
    _fontFileName = nil;
    [_speakerFileName release];
    _speakerFileName = nil;
    [_panelFileName release];
    _panelFileName = nil;
    [_msg release];
    _msg = nil;
    //[_textLabel release];
    //_textLabel = nil;
    //[_dialogPanel release];
    //_dialogPanel = nil;
    //[_speaker release];
    //_speaker =nil;
    [super dealloc];
}

@end
