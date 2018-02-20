//
//  BlinkyView.m
//  Blinky
//
//  Created by David Robinson on 08-FEB-02018.
//  Edited  by David Robinson on 20-FEB-02018.
//  Copyright © 2018 Imperfect Code. All rights reserved.
//
//  Originally based on the tutorial "Write a Screen Saver: Part I" by Brian Christensen
//  http://cocoadevcentral.com/articles/000088.php
//
//  Heavily modified by David Robinson
//

#import "BlinkyView.h"

@implementation BlinkyView

static NSString * const MyModuleName = @"online.imperfectcode.Blinky";

bool DEBUG_SET = FALSE;
bool DEBUG_ONCE = FALSE;

bool CLEAR_RESET = TRUE;
unsigned int CLEAR_CYCLE=0;


float WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_SHORT, WINDOW_LONG, WINDOW_WIDTH_OLD;
unsigned int WINDOW_TALL=0;

unsigned int COUNT_SHORT, COUNT_LONG;
float ORIGIN_SHORT, ORIGIN_LONG;
float BOX_SIZE;
float BOX_GUTTER;
float OFFSET_SHORT, OFFSET_LONG;
float BUFFER_SHORT, BUFFER_LONG;

unsigned int SHAPE_TYPE;

unsigned int COLOUR_RANDOM;
unsigned int COLOUR_CYCLE;
unsigned int COLOUR_CYCLE_RESET = 1000;

//float COLOUR_R, COLOUR_G, COLOUR_B, COLOUR_A;
float COLOUR_H, COLOUR_S, COLOUR_B, COLOUR_A;

unsigned int CLEAR_COUNT;
unsigned int LOOP_COUNT=5;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        ScreenSaverDefaults *defaults;
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
        
        // Register our default values
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"NO", @"DrawFilledShapes",
                                    @"NO", @"DrawOutlinedShapes",
                                    @"YES", @"DrawBoth",
                                    @"NO", @"DebugMode",
                                    nil]];
        
        [self setAnimationTimeInterval:1/30.0];
        if (isPreview) {
            //COUNT_SHORT = SSRandomIntBetween(3,13);
            //BOX_GUTTER = SSRandomIntBetween(5,15);
        }
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    NSBezierPath *path;
    NSRect rect;
    NSSize WINDOW_SIZE;
    NSColor *color;
    ScreenSaverDefaults *defaults;
    
    WINDOW_SIZE = self.bounds.size;
    
    WINDOW_WIDTH = WINDOW_SIZE.width;
    WINDOW_HEIGHT = WINDOW_SIZE.height;
    
    if ( WINDOW_WIDTH_OLD == !WINDOW_WIDTH )
    {
        CLEAR_RESET = TRUE;
    }
    
    WINDOW_WIDTH_OLD = WINDOW_WIDTH;
    
    if ( WINDOW_WIDTH < WINDOW_HEIGHT )
    {
        WINDOW_LONG = WINDOW_HEIGHT;
        WINDOW_SHORT = WINDOW_WIDTH;
        WINDOW_TALL = 1;
    }
    else
    {
        WINDOW_LONG = WINDOW_WIDTH;
        WINDOW_SHORT = WINDOW_HEIGHT;
        WINDOW_TALL = 0;
    }
    
    // Set initial conditions
    if ( CLEAR_RESET )
    {
        COLOUR_CYCLE_RESET =SSRandomIntBetween( 101, 997);
        COLOUR_CYCLE = COLOUR_CYCLE_RESET + 1;
        
        COUNT_SHORT = SSRandomIntBetween( 5, 47);
        
        //CLEAR_COUNT = pow(COUNT_SHORT,0.5);
        
        // Calculate box size
        BOX_SIZE = WINDOW_SHORT / COUNT_SHORT;
        
        //BOX_GUTTER = SSRandomIntBetween( 5, 31);
        //BOX_GUTTER = 10;
        
        BOX_GUTTER = SSRandomFloatBetween( 5, ( floor(  BOX_SIZE - 1 ) ) );
        
        COUNT_LONG = floor( WINDOW_LONG / BOX_SIZE );
        
        if ( [defaults boolForKey:@"DebugMode"] || DEBUG_SET )
        {
            NSLog(@"blinkytest - BOX_SIZE %f",BOX_SIZE);
            NSLog(@"blinkytest - WINDOW_SHORT %f",WINDOW_SHORT);
            NSLog(@"blinkytest - WINDOW_LONG %f",WINDOW_LONG);
            NSLog(@"blinkytest - COUNT_SHORT %d",COUNT_SHORT);
            NSLog(@"blinkytest - COUNT_LONG %d",COUNT_LONG);
            NSLog(@"blinkytest - BOX_GUTTER %f",BOX_GUTTER);
        }
        
        BUFFER_SHORT = ( WINDOW_SHORT - ( BOX_SIZE * COUNT_SHORT) ) / (COUNT_SHORT-1);
        BUFFER_LONG = ( WINDOW_LONG - ( BOX_SIZE * COUNT_LONG) ) / (COUNT_LONG-1);
        
        rect.size = NSMakeSize( WINDOW_WIDTH, WINDOW_HEIGHT );
        rect.origin = NSMakePoint( 0 , 0 ) ;
        path = [NSBezierPath bezierPathWithRect:rect];
        color = [NSColor blackColor];
        [color set];
        [path fill];
        
        CLEAR_RESET = FALSE;
    }
    
    //CLEAR_CYCLE++;
    //if ( CLEAR_CYCLE > 10000 )
    //{
    //    CLEAR_RESET = TRUE;
    //    CLEAR_CYCLE = 0;
    //}
    
    // Change colours
    COLOUR_CYCLE++;
    COLOUR_S = 1.0;
    COLOUR_B = 1.0;
    COLOUR_A = 1.0;
    if ( COLOUR_CYCLE > COLOUR_CYCLE_RESET ) {
        COLOUR_CYCLE = 0;
        CLEAR_COUNT = pow( COUNT_SHORT, 0.2 ) * SSRandomIntBetween( 1, 9 );
        COLOUR_RANDOM = SSRandomIntBetween( 0, 3 );
        switch ( COLOUR_RANDOM )
        {
            case 0:
                COLOUR_RANDOM = SSRandomIntBetween( 0, 12 );
                switch (COLOUR_RANDOM)
            {
                case 0: // white
                default:
                    COLOUR_H = (CGFloat)0/360;
                    COLOUR_S = 0.0;
                    break;
                case 1: // red
                    COLOUR_H = (CGFloat)0/360;
                    break;
                case 2: // orange
                    COLOUR_H = (CGFloat)30/360;
                    break;
                case 3: // yellow
                    COLOUR_H = (CGFloat)60/360;
                    break;
                case 4: // chartreuse green
                    COLOUR_H = (CGFloat)90/360;
                    break;
                case 5: // green
                    COLOUR_H = (CGFloat)120/360;
                    break;
                case 6: // spring green
                    COLOUR_H = (CGFloat)150/360;
                    break;
                case 7: // cyan
                    COLOUR_H = (CGFloat)180/360;
                    break;
                case 8: // azure
                    COLOUR_H = (CGFloat)210/360;
                    break;
                case 9: // blue
                    COLOUR_H = (CGFloat)240/360;
                    break;
                case 10: // violet
                    COLOUR_H = (CGFloat)270/360;
                    break;
                case 11: // magenta
                    COLOUR_H = (CGFloat)300/360;
                    break;
                case 12: // rose
                    COLOUR_H = (CGFloat)330/360;
                    break;
            }
            case 1:
            case 2:
            case 3:
            default:
                COLOUR_RANDOM = SSRandomIntBetween( 0, 5 );
                switch (COLOUR_RANDOM)
            {
                case 0: // white
                default:
                    COLOUR_H = (CGFloat)0/360;
                    COLOUR_S = 0.0;
                    break;
                case 1: // red
                    COLOUR_H = (CGFloat)0/360;
                    break;
                case 2: // orange
                    COLOUR_H = (CGFloat)30/360;
                    break;
                case 3: // yellow
                    COLOUR_H = (CGFloat)60/360;
                    break;
                case 4: // green
                    COLOUR_H = (CGFloat)120/360;
                    break;
                case 5: // blue
                    COLOUR_H = (CGFloat)240/360;
                    break;
            }
        }
    }
    
    
    if ( [defaults boolForKey:@"DebugMode"] || DEBUG_SET )
    {
        if ( !DEBUG_ONCE )
        {
            DEBUG_ONCE =TRUE;
            rect.size = NSMakeSize( WINDOW_WIDTH, WINDOW_HEIGHT );
            rect.origin = NSMakePoint( 0 , 0 ) ;
            path = [NSBezierPath bezierPathWithRect:rect];
            color = [NSColor whiteColor];
            [color set];
            [path fill];
        }
    }
    
    if ([defaults boolForKey:@"DebugMode"] || DEBUG_SET )
    {
        LOOP_COUNT = 100;
    }
    
    rect.size = NSMakeSize( BOX_SIZE - (BOX_GUTTER/2) , BOX_SIZE - (BOX_GUTTER/2));
    
    for (int i=0; i<LOOP_COUNT; i++)
    {
        OFFSET_LONG = SSRandomIntBetween( 0, COUNT_LONG-1);
        OFFSET_SHORT = SSRandomIntBetween( 0, COUNT_SHORT-1);
        
        //NSLog(@"OFFSET_LONG %d",OFFSET_LONG);
        //NSLog(@"OFFSET_SHORT %d",OFFSET_SHORT);
        
        //ORIGIN_LONG = ( OFFSET_LONG*WINDOW_SHORT / COUNT_SHORT ) + OFFSET_LONG*BUFFER_LONG + (BOX_GUTTER/2);
        //ORIGIN_SHORT = ( OFFSET_SHORT*WINDOW_SHORT / COUNT_SHORT ) + (BOX_GUTTER/2) ;
        
        ORIGIN_LONG = ( OFFSET_LONG*BOX_SIZE ) + OFFSET_LONG*BUFFER_LONG + (BOX_GUTTER/4);
        ORIGIN_SHORT = ( OFFSET_SHORT*BOX_SIZE ) + OFFSET_SHORT*BUFFER_SHORT + (BOX_GUTTER/4) ;
        
        //NSLog(@"ORIGIN_LONG %d",ORIGIN_LONG);
        //NSLog(@"ORIGIN_SHORT %d",ORIGIN_SHORT);
        //NSLog(@"WINDOW_LONG %d",WINDOW_LONG);
        //NSLog(@"WINDOW_SHORT %d",WINDOW_SHORT);
        
        if ( WINDOW_TALL == 0 ) {
            rect.origin = NSMakePoint( ORIGIN_LONG , ORIGIN_SHORT ) ;
        }
        else
        {
            rect.origin = NSMakePoint( ORIGIN_SHORT , ORIGIN_LONG ) ;
        }
        
        // Decide what kind of shape to draw
        //SHAPE_TYPE = SSRandomIntBetween( 0, 1 );
        SHAPE_TYPE = 1;
        
        if ([defaults boolForKey:@"DebugMode"] || DEBUG_SET )
        {
            SHAPE_TYPE = 1;
        }
        
        switch (SHAPE_TYPE)
        {
            case 0: // rect
                path = [NSBezierPath bezierPathWithRect:rect];
                break;
                
            case 1: // circle
            default:
                path = [NSBezierPath bezierPathWithOvalInRect:rect];
                break;
        }
        
        //clear space first

        color = [NSColor blackColor];
        [color set];
        
        // And finally draw it
        [path fill];
        
        // Calculate a random color
        COLOUR_B = SSRandomFloatBetween( 0.0, 1.0 );
        
        if ( [defaults boolForKey:@"DebugMode"] || DEBUG_SET )
        {
            color = [NSColor colorWithCalibratedHue:COLOUR_H
                                         saturation:COLOUR_S
                                         brightness:1.0
                                              alpha:COLOUR_A];
        }
        else
        {
            color = [NSColor colorWithCalibratedHue:COLOUR_H
                                         saturation:COLOUR_S
                                         brightness:COLOUR_B
                                              alpha:COLOUR_A];
        }
        
        [color set];
        
        // And finally draw it
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
        
        //if ([defaults boolForKey:@"DrawBoth"])
        //{
        //    if (SSRandomIntBetween( 0, 1 ) == 0)
        [path fill];
        //    else
        //        [path stroke];
        //}
        //else if ([defaults boolForKey:@"DrawFilledShapes"])
        //    [path fill];
        //else
        //    [path stroke];
        
    }
    
    // and clear some boxes
    
    
    for (int i=0; i<(CLEAR_COUNT); i++)
    {
        
        rect.size = NSMakeSize( BOX_SIZE , BOX_SIZE );
        
        // Calculate random origin point
        
        OFFSET_LONG = SSRandomIntBetween( 0, COUNT_LONG-1);
        OFFSET_SHORT = SSRandomIntBetween( 0, COUNT_SHORT-1);
        
        ORIGIN_LONG = ( OFFSET_LONG*BOX_SIZE ) + OFFSET_LONG*BUFFER_LONG;
        ORIGIN_SHORT = ( OFFSET_SHORT*BOX_SIZE ) + OFFSET_SHORT*BUFFER_SHORT;
        
        if ( WINDOW_TALL == 0 ) {
            rect.origin = NSMakePoint( ORIGIN_LONG , ORIGIN_SHORT ) ;
        }
        else
        {
            rect.origin = NSMakePoint( ORIGIN_SHORT , ORIGIN_LONG ) ;
        }
        
        // Make a rectangle
        path = [NSBezierPath bezierPathWithRect:rect];
        
        if ( ![defaults boolForKey:@"DebugMode"] && !DEBUG_SET )
        {
            
            color = [NSColor blackColor];
            
            [color set];
            
            // And finally draw it
            [path fill];
            
        }
        else
        {
            color = [NSColor whiteColor];
            
            [color set];
            
            // And finally draw it
            
            [path stroke];
        }
    }
    
    return;
    
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    if (!configSheet)
    {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self])
        {
            NSLog( @"Failed to load configure sheet." );
            NSBeep();
        }
    }
    
    [drawFilledShapesOption setState:[defaults boolForKey:@"DrawFilledShapes"]];
    [drawOutlinedShapesOption setState:[defaults boolForKey:@"DrawOutlinedShapes"]];
    [drawBothOption setState:[defaults boolForKey:@"DrawBoth"]];
    [debugModeOption setState:[defaults boolForKey:@"DebugMode"]];
    
    return configSheet;
}

- (IBAction)cancelClick:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)okClick:(id)sender
{
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    // Update our defaults
    [defaults setBool:[drawFilledShapesOption state] forKey:@"DrawFilledShapes"];
    [defaults setBool:[drawOutlinedShapesOption state] forKey:@"DrawOutlinedShapes"];
    [defaults setBool:[drawBothOption state] forKey:@"DrawBoth"];
    [defaults setBool:[debugModeOption state] forKey:@"DebugMode"];
    
    // Save the settings to disk
    [defaults synchronize];
    
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

@end
