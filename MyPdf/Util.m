//
//  Util.m
//  read
//
//  Created by gao wenjian on 14-2-21.
//
//

#import "Util.h"

@implementation Util


+ (NSArray *)sortArrayByCondition:(NSString *)condition dataArray:(NSArray *)array
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:condition ascending:YES];
    NSMutableArray *combinedMessage = [NSMutableArray arrayWithArray:array];
    return [combinedMessage sortedArrayUsingDescriptors:@[sort]];
}
@end
