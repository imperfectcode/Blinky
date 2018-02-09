//
//  BlinkyView.m
//  Blinky
//
//  Created by David Robinson on 8/2/18.
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
int monWidth, monHeight, monLong, monShort;
int shortCount=9;
int longCount;
int longOrigin, shortOrigin;
int gutterShort=10;
int gutterLong;
int boxSizeShort;
int longOffset;
int shortOffset;
int longBuffer;
int colorRandom;
int countCycle = 0;
int countReset = 1000;
unsigned int monTall=0;
float red, green, blue, alpha;
int clearTimes = 10;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    shortCount = SSRandomIntBetween( 7, 31);
    gutterShort = SSRandomIntBetween( 5, 17);
    countReset =SSRandomIntBetween( 100, 1000);
    
    clearTimes = shortCount;
    
    colorRandom = SSRandomIntBetween( 0, 3);
    
    switch (colorRandom) {
        case 0: // red
            red=255.0;
            green=0.0;
            blue=0.0;
            break;
            
        case 1: // green
            red=0.0;
            green=255.0;
            blue=0.0;
            break;
            
        case 2: // blue
            red=0.0;
            green=0.0;
            blue=255.0;
            break;
            
        case 3: //white
        default:
            red=255.0;
            green=255.0;
            blue=255.0;
            break;
    }
    
    //red = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    //green = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    //blue = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    
    
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
        {
            ScreenSaverDefaults *defaults;
            
            defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
            
            // Register our default values
            [defaults registerDefaults:@{
                                         @"DrawFilledShapes": @"NO",
                                         @"DrawOutlinedShapes": @"NO",
                                         @"DrawBoth": @"YES"}];
            
            self.animationTimeInterval = 1/30.0;
            
            if (isPreview) {
                shortCount = SSRandomIntBetween(3,5);
                gutterShort = SSRandomIntBetween(5,15);
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
    NSSize size;
    NSColor *color;
    int shapeType;
    ScreenSaverDefaults *defaults;
    
    size = self.bounds.size;
    
    monWidth = size.width;
    monHeight = size.height;
    
    if ( monWidth < monHeight )
    {
        monLong = monHeight;
        monShort = monWidth;
        monTall = 1;
    }
    else
    {
        monLong = monWidth;
        monShort = monHeight;
        monTall = 0;
    }
    
    // Change colours
    countCycle++;
    if (countCycle > countReset) {
        colorRandom = SSRandomIntBetween( 0, 3);
        countCycle = 0;
        switch (colorRandom) {
            case 0: // red
                red=255.0;
                green=0.0;
                blue=0.0;
                break;
                
            case 1: // green
                red=0.0;
                green=255.0;
                blue=0.0;
                break;
                
            case 2: // blue
                red=0.0;
                green=0.0;
                blue=255.0;
                break;
                
            case 3: //white
            default:
                red=255.0;
                green=255.0;
                blue=255.0;
                break;
        }
        
    }
    
    
    // Calculate random width and height
    /*
     rect.size = NSMakeSize( SSRandomFloatBetween( size.width / 100.0,
     size.width / 10.0 ),
     SSRandomFloatBetween( size.height / 100.0,
     size.height / 10.0 ));
     */
    
    //rect.size = NSMakeSize(  size.height / 10.0, size.height / 10.0);
    //rectC.size = NSMakeSize(  size.height / 10.0, size.height / 10.0);
    
    boxSizeShort = monShort / shortCount;
    
    longCount = ( monLong / boxSizeShort );
    
    //NSLog(@"longCount %d",longCount);
    
    gutterLong = gutterShort;
    longBuffer = ( monLong - ( boxSizeShort * longCount) ) / longCount;
    
    rect.size = NSMakeSize( boxSizeShort - gutterShort , boxSizeShort - gutterShort);
    
    // Calculate random origin point
    //rect.origin = SSRandomPointForSizeWithinRect( rect.size, [self bounds] ) ;
    //rect.origin = NSMakePoint(1.0, 1.0) ;
    //rect.origin = NSMakePoint(SSRandomIntBetween( 0, 16-1)*size.height / 9,
    //                          SSRandomIntBetween( 0, 9-1)*size.height / 9) ;
    
    //NSLog(@"monTall %d",monTall);
    
    longOffset = SSRandomIntBetween( 0, longCount-1);
    shortOffset = SSRandomIntBetween( 0, shortCount-1);
    //NSLog(@"longOffset %d",longOffset);
    //NSLog(@"shortOffset %d",shortOffset);
    longOrigin = ( longOffset*monShort / shortCount ) + longOffset*longBuffer + (gutterLong/2);
    shortOrigin = ( shortOffset*monShort / shortCount ) + (gutterShort/2) ;
    
    //NSLog(@"longOrigin %d",longOrigin);
    //NSLog(@"shortOrigin %d",shortOrigin);
    //NSLog(@"monLong %d",monLong);
    //NSLog(@"monShort %d",monShort);
    
    if ( monTall == 0 ) {
        rect.origin = NSMakePoint( longOrigin , shortOrigin ) ;
    }
    else
    {
        rect.origin = NSMakePoint( shortOrigin , longOrigin ) ;
    }
    
    // Decide what kind of shape to draw
    shapeType = SSRandomIntBetween( 0, 1 );
    
    switch (shapeType)
    {
        case 0: // rect
            path = [NSBezierPath bezierPathWithRect:rect];
            break;
            
        case 1: // circle
        default:
            path = [NSBezierPath bezierPathWithOvalInRect:rect];
            break;
    }
    
    // Calculate a random color
    alpha = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    
    color = [NSColor colorWithCalibratedRed:red
                                      green:green
                                       blue:blue
                                      alpha:alpha];
    
    [color set];
    
    // And finally draw it
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    if ([defaults boolForKey:@"DrawBoth"])
    {
        if (SSRandomIntBetween( 0, 1 ) == 0)
            [path fill];
        else
            //[path stroke];
            [path fill];
    }
    else if ([defaults boolForKey:@"DrawFilledShapes"])
        [path fill];
    else
        //[path stroke];
    [path fill];
    
    
    
    // and clear some boxes
    
    for (int i=0; i<clearTimes; i++)
    {
        
        rect.size = NSMakeSize( boxSizeShort , boxSizeShort );
        
        // Calculate random origin point
        
        longOffset = SSRandomIntBetween( 0, longCount-1);
        shortOffset = SSRandomIntBetween( 0, shortCount-1);
        longOrigin = ( longOffset*monShort / shortCount ) + longOffset*longBuffer;
        shortOrigin = ( shortOffset*monShort / shortCount ) ;
        
        if ( monTall == 0 ) {
            rect.origin = NSMakePoint( longOrigin , shortOrigin ) ;
        }
        else
        {
            rect.origin = NSMakePoint( shortOrigin , longOrigin ) ;
        }
        
        
        // Make a rectangle
        path = [NSBezierPath bezierPathWithRect:rect];
        
        // make it black
        color = [NSColor colorWithCalibratedRed:0.0
                                          green:0.0
                                           blue:0.0
                                          alpha:255.0];
        
        [color set];
        
        // And finally draw it
        [path fill];
    }
    
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
    
    // Save the settings to disk
    [defaults synchronize];
    
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

@end
