//
//  NewPdfView.h
//  MyPdf
//
//  Created by wenjian gao on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPdfView : UIView
{
}

@property (nonatomic,assign) int pageIndex;

- (void)DisplayPDFPage :(size_t )pageNumber  filename:(NSString *)filename;
@end
