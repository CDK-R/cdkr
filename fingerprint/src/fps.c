/* Functions for using the "fps" hex-based fingerprint file format */

#include <stdio.h>
#include <string.h>

//#include "heapq.h"
#include "chemfp.h"

/* Internal function to parse a line from the fps block.
   The line MUST match /[0-9A-Fa-f]+\s\S+.*\n/
   It MUST be known to end with a newline. */
static int parse_line(
		      int hex_len,  /* The expected length of the hex field, or -1 if unknown
				       (If it's known then it's used to validate.) */
		      char *line,   /* The input line */
		      char **id_start, int *id_len  /* After a successful return, these will contain
						       the start position and length of the id field */
		      ) {
  int fp_field_len, ws_len, tmp_id_len;
  char *s;

  /* Find the hex fingerprint and check that the length is appropriate */
  fp_field_len = strspn(line, "0123456789abcdefABCDEF");
  if (fp_field_len == 0)
    return CHEMFP_MISSING_FINGERPRINT;
  if (fp_field_len % 2 != 0)
    return CHEMFP_BAD_FINGERPRINT;
  if (hex_len != -1 && hex_len != fp_field_len)
    return CHEMFP_UNEXPECTED_FINGERPRINT_LENGTH;

  s = line+fp_field_len;
  /* The only legal thing here is a space or a tab. */
  /* There might be some other character, including a NUL */
  /* XXX Why do I allow multiple whitespace ? Check the spec! */
  ws_len = strspn(s, " \t");  // \v? \f? \r?
  if (ws_len == 0) {
    switch (s[0]) {
    case '\n': return CHEMFP_MISSING_ID;
    case '\r': if (s[1] == '\n') return CHEMFP_MISSING_ID; /* else fallthrough */
    case '\v':
    case '\f': return CHEMFP_UNSUPPORTED_WHITESPACE;
    default: return CHEMFP_BAD_FINGERPRINT;
    }
  }
  s += ws_len;

  /* You must pass in a newline-terminated string to this function.
     Therefore, this function will finish while inside the string.
     Note that I'm also checking for illegal whitespace here. */
  tmp_id_len = strcspn(s, " \t\n\v\f\r");
  switch (s[tmp_id_len]) {
  case '\0': return CHEMFP_BAD_ID;
  case '\v':
  case '\f': return CHEMFP_UNSUPPORTED_WHITESPACE;
  case '\r': if (s[tmp_id_len+1] != '\n') return CHEMFP_UNSUPPORTED_WHITESPACE;
    break;
  }
  *id_start = s;
  *id_len = tmp_id_len;
  return CHEMFP_OK;
}

/* Go to the start of the next line. s may be at a newline already. */
static char *chemfp_to_next_line(char *s) {
  while (*s != '\n')
    s++;
  return s+1;
}


int chemfp_fps_line_validate(int hex_len, int line_len, char *line) {
  char *id_start;
  int id_end;
  if (line_len==0 || line[line_len-1] != '\n')
    return CHEMFP_MISSING_NEWLINE;
  return parse_line(hex_len, line, &id_start, &id_end);
}

