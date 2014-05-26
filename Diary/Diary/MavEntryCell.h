//
//  MavEntryCell.h
//  Diary
//
//  Created by Mav3r1ck on 5/26/14.
//  Copyright (c) 2014 Mav3r1ck. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MavDiaryEntry;

@interface MavEntryCell : UITableViewCell

+ (CGFloat)heightForEntry:(MavDiaryEntry *)entry;

- (void)configureCellForEntry:(MavDiaryEntry *)entry;

@end
