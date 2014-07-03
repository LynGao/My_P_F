//
//  PdfHeaderBar.m
//  read
//
//  Created by gao wenjian on 14-2-21.
//
//

#import "PdfHeaderBar.h"

@implementation PdfHeaderBar

- (id)initWithFrame:(CGRect)frame
           onTarget:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createToolBarOnTarget:target];
    }
    return self;
}

- (void)createToolBarOnTarget:(id)target
{
    [self setBarStyle:UIBarStyleBlack];
    [self setTranslucent:YES];
    [self setItems:[self barButtonItems:target]];
}

- (NSArray *)barButtonItems:(id)target
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:target
                                                                              action:@selector(back)];
    
    return [NSArray arrayWithObjects:backItem, nil];
}

@end
