//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Hope on 11/4/15.
//  Copyright (c) 2015 Hope Elizabeth. All rights reserved.
//

import Foundation;

class RecordedAudio
{
    var title: String!;
    var recordingFilePathURL: NSURL!;

    init (title: String!, recordingFilePathURL: NSURL!)
    {
        self.title = title;
        self.recordingFilePathURL = recordingFilePathURL;
    }
}