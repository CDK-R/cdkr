#ifndef CHEMFP_H
#define CHEMFP_H

/* Errors are always negative numbers. */
enum chemfp_errors {
  CHEMFP_OK = 0,
  CHEMFP_BAD_ARG = -1,  /* Generic error; not used */

  /* File format errors */
  CHEMFP_UNSUPPORTED_WHITESPACE = -30,
  CHEMFP_MISSING_FINGERPRINT = -31,
  CHEMFP_BAD_FINGERPRINT = -32,
  CHEMFP_UNEXPECTED_FINGERPRINT_LENGTH = -33,
  CHEMFP_MISSING_ID = -34,
  CHEMFP_BAD_ID = -35,
  CHEMFP_MISSING_NEWLINE = -36,
};

/* This gives compile-time version information. */
/* Use "chemfp_version" for run-time version information */
#define CHEMFP_MAJOR_VERSION 0
#define CHEMFP_MINOR_VERSION 9
#define CHEMFP_PATCHLEVEL 0

/* This is of the form (\d+\.\d+) (\.\d)? ((a|b|pre)\d+)
     for examples:  0.9, 1.0.4, 1.0pre2.
 The "a"lpha, "b"eta, and "pre"view suffixes will never be seen in production releases */
#define CHEMFP_VERSION_STRING "0.9a1"

/* Return the CHEMFP_VERSION.  */
const char *chemfp_version(void);

/* Convert an error code to a string description */
const char *chemfp_strerror(int err);


/*** Low-level operations directly on hex fingerprints ***/

/* Return 1 if the string contains only hex characters; 0 otherwise */
int chemfp_hex_isvalid(int len, const unsigned char *fp);

/* Return the population count of a hex fingerprint, otherwise return -1 */
int chemfp_hex_popcount(int len, const unsigned char *fp);

/* Return the population count of the intersection of two hex fingerprints,
   otherwise return -1. */
int chemfp_hex_intersect_popcount(int len, const unsigned char *fp1,
                                  const unsigned char *fp2);

/* Return the Tanitoto between two hex fingerprints, or -1.0 for invalid fingerprints
   If neither fingerprint has any set bits then return 1.0 */
double chemfp_hex_tanimoto(int len, const unsigned char *fp1,
                           const unsigned char *fp2);

/* Return 1 if the query fingerprint is contained in the target, 0 if it isn't,
   or -1 for invalid fingerprints */
int chemfp_hex_contains(int len, const unsigned char *query_fp,
                        const unsigned char *target_fp);

/**** Low-level operations directly on byte fingerprints ***/

/* Return the population count of a byte fingerprint */
int chemfp_byte_popcount(int len, const unsigned char *fp);

/* Return the population count of the intersection of two byte fingerprints */
int chemfp_byte_intersect_popcount(int len, const unsigned char *fp1,
                                   const unsigned char *fp2);

/* Return the Tanitoto between two byte fingerprints, or -1.0 for invalid fingerprints
   If neither fingerprint has any set bits then return 1.0 */
double chemfp_byte_tanimoto(int len, const unsigned char *fp1,
                            const unsigned char *fp2);

/* Return 1 if the query fingerprint is contained in the target, 0 if it isn't */
int chemfp_byte_contains(int len, const unsigned char *query_fp,
                         const unsigned char *target_fp);


/**** Functions which work with data from an fps block ***/

/* NOTE: an "fps block" means "one or more fingerprint lines from an fps
   file." These contain the hex fingerprint and the identifier, plus optional
   additional fields. The fps block must end with a newline. */

/* Return 0 if string is a valid fps fingerprint line, otherwise an error code */
int chemfp_fps_line_validate(int hex_len,  // use -1 if not known
                             int line_len, char *line);


/* Compute Tanimoto scores for each line in the fps block and report all
   scores which are greater than or equal to the specified threshold. Callers
   must preallocate enough space in id_starts, id_lens, and scores for the
   results. */
int chemfp_fps_tanimoto(
    int hex_len, char *hex_query,   // The query fingerprint, in hex

    // Target block data, in fps format. Last character must be a newline.
    int target_block_len, char *target_block,  

    double threshold,    // Report only those values >= threshold
    int *num_found,      // Will be set to the number of fingerprints which matched
    char **id_starts, int *id_lens,     // id locations in the current block
    double *scores,      // Corresponding Tanimoto similarity score

    // (optional) track the line number. The caller must initialize the
    // number if not NULL. All this function does is increment the count
    int *lineno
  );


/* Return the number of fingerprints in the fps block which are greater
   than or equal to the specified threshold. */
int chemfp_fps_tanimoto_count(int hex_len, char *hex_query,
                              int target_block_len, char *target_block,
                              double threshold,
                              int *num_found, int *lineno);

typedef struct {
  int size;           /* current heap size */
  int k;              /* max number of elements to find */
  int unique_idx;     /* counter if a unique index is needed */
  int _reserved;      /* used for nice alignment on 64 bit machines */
  double threshold;   /* initial threshold */

  /* These all point to arrays of size k */
  int *indicies;      /* [k]; contains a unique id or index */
  double *scores;     /* [k]; the Tanimoto similarity */
  char **id_starts;   /* [k]; location (in the current block) of the start of the id */
  int *id_lens;       /* [k]; length of that id */
} chemfp_heap;


/* Initialize the chemfp_heap data structure.
   The caller must set things up correctly, including allocating enough memory */
void chemfp_fps_heap_init(chemfp_heap *heap,  /* the structure to initialize */
                          int k, double threshold,
                          int *indicies, double *scores,
                          char **id_starts, int *id_lens);

/* Update the heap based on the lines in an fps fingerprint data block. */
int chemfp_fps_heap_update_tanimoto(chemfp_heap *heap,
                                    int hex_len, char *hex_query,
                                    int target_block_len, char *target_block,
                                    int *lineno);

/* Call this after the last fps block, in order to convert the heap into an
   sorted array. */
void chemfp_fps_heap_finish_tanimoto(chemfp_heap *heap);


/***** The byte-oriented algorithms  ********/



int chemfp_nlargest_tanimoto_block(
        int n,
        int query_len, unsigned char *query_fp,
        int num_targets, unsigned char *target_block, int offset, int storage_len,
        double threshold,
        int *indicies, double *scores);

int chemfp_hex_tanimoto_block(
        int n,
        int len, unsigned char *hex_query_fp,
        int target_len, unsigned char *target_block,
        double threshold,
        double *scores, unsigned char **start_ids, int *id_lens, int *lineno);

int chemfp_byte_intersect_popcount_count(
        int len, unsigned char *query_fp,
        int num_targets, unsigned char *target_block, int offset, int storage_len,
  int min_overlap);

#endif /* CHEMFP_H */

