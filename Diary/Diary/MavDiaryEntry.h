//
//  MavDiaryEntry.h
//  Diary
//
//  Created by Mav3r1ck on 5/25/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ENUM(int16_t, MavDiaryEntryMood) {
    MavDiaryEntryMoodGood = 0,
    MavDiaryEntryMoodAverage = 1,
    MavDiaryEntryMoodBad = 2,
};

@interface MavDiaryEntry : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@property (nonatomic, readonly) NSString *sectionName;

@end
