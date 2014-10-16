/*
 Copyright (c) 2014, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of Pierre-Olivier Latour may not be used to endorse
 or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#if !__has_feature(objc_arc)
#error XLFacility requires ARC
#endif

#import "XLFunctions.h"
#import "XLPrivate.h"

#define kInvalidUTF8Placeholder "<INVALID UTF8 STRING>"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"

void XLLogCMessage(const char* tag, int level, const char* format, ...) {
  va_list arguments;
  va_start(arguments, format);
  NSString* message = [[NSString alloc] initWithFormat:[NSString stringWithUTF8String:format] arguments:arguments];
  va_end(arguments);
  [XLSharedFacility logMessage:message withTag:(tag ? [NSString stringWithUTF8String:tag] : nil) level:level];
}

#pragma clang diagnostic pop

NSData* XLConvertNSStringToUTF8String(NSString* string) {
  NSData* utf8Data = nil;
  if (string) {
    utf8Data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    if (!utf8Data) {
      utf8Data = [NSData dataWithBytesNoCopy:kInvalidUTF8Placeholder length:strlen(kInvalidUTF8Placeholder) freeWhenDone:NO];
      XLOG_DEBUG_UNREACHABLE();
    }
  }
  return utf8Data;
}

const char* XLConvertNSStringToUTF8CString(NSString* string) {
  const char* utf8String = NULL;
  if (string) {
    utf8String = [string UTF8String];
    if (!utf8String) {
      utf8String = kInvalidUTF8Placeholder;
      XLOG_DEBUG_UNREACHABLE();
    }
  }
  return utf8String;
}
