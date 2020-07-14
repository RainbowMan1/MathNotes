//
//  NotesEditorViewController.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "ZSSRichTextEditor.h"


NS_ASSUME_NONNULL_BEGIN

@interface NotesEditorViewController : ZSSRichTextEditor
@property (strong, nonatomic) Note *note;
@end

NS_ASSUME_NONNULL_END
