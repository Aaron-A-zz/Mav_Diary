//
//  MavDiaryEntry.m
//  Diary
//
//  Created by Mav3r1ck on 5/25/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

#import "MavDiaryEntry.h"


@implementation MavDiaryEntry

@dynamic date;
@dynamic body;
@dynamic imageData;
@dynamic mood;
@dynamic location;

-(NSString *)sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM YYYY"];
    
    return [dateFormatter stringFromDate:date];
    
}

@end
