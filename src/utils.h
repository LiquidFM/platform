#ifndef UTILS_H_140420131006
#define UTILS_H_140420131006

#include <limits.h>
#include <platform/platform.h>

#ifdef __cplusplus
#include <new>
#endif /* __cplusplus */


#if PLATFORM_OS(WINDOWS)

/* Windows defines min/max macroses and this prevents using of std::max and std::min, so we undef them. */
#ifdef max
#undef max
#endif
#ifdef min
#undef min
#endif

#endif


#define PLATFORM_MAKE_NONCOPYABLE(ClassName)    \
    private:                                    \
        ClassName(const ClassName &);           \
        ClassName &operator=(const ClassName &);

#if PLATFORM_COMPILER_SUPPORTS(MOVE_SEMANTIC)
#define PLATFORM_MAKE_NONMOVEABLE(ClassName)    \
    private:                                    \
        ClassName(ClassName &&);                \
        ClassName &operator=(ClassName &&);
#else
#define PLATFORM_MAKE_NONMOVEABLE(ClassName)
#endif


#define PLATFORM_MAKE_STACK_ONLY                                      \
private:                                                              \
    void *operator new(std::size_t) throw (std::bad_alloc);             \
    void *operator new[](std::size_t) throw (std::bad_alloc);         \
    void *operator new(std::size_t, const std::nothrow_t &) throw();  \
    void *operator new[](std::size_t, const std::nothrow_t&) throw(); \
    inline void *operator new(std::size_t, void* __p) throw();        \
    inline void *operator new[](std::size_t, void* __p) throw();


#if PLATFORM_COMPILER(GCC)
#define PLATFORM_PRETTY_FUNCTION __PRETTY_FUNCTION__
#else
#define PLATFORM_PRETTY_FUNCTION __FUNCTION__
#endif


#if PLATFORM_COMPILER_SUPPORTS(EXCEPTIONS)
#  define PLATFORM_TRY try
#  define PLATFORM_CATCH(A) catch (A)
#  define PLATFORM_THROW(A) throw A
#  define PLATFORM_RETHROW throw
#else
#  define PLATFORM_TRY if (true)
#  define PLATFORM_CATCH(A) else
#  define PLATFORM_THROW(A)
#  define PLATFORM_RETHROW
#endif


#define PLATFORM_LO_BYTE(uint16_value) static_cast<uint8_t>(static_cast<uint16_t>(uint16_value) & 0x00FF)
#define PLATFORM_HI_BYTE(uint16_value) static_cast<uint8_t>((static_cast<uint16_t>(uint16_value) & 0xFF00) >> CHAR_BIT)
#define PLATFORM_LO_WORD(uint32_value) static_cast<uint16_t>(static_cast<uint32_t>(uint32_value) & 0x0000FFFF)
#define PLATFORM_HI_WORD(uint32_value) static_cast<uint16_t>((static_cast<uint32_t>(uint32_value) & 0xFFFF0000) >> (CHAR_BIT * 2))
#define PLATFORM_LO_DWORD(uint64_value) static_cast<uint32_t>(static_cast<uint64_t>(uint64_value) & 0x00000000FFFFFFFF)
#define PLATFORM_HI_DWORD(uint64_value) static_cast<uint32_t>((static_cast<uint64_t>(uint64_value) & 0xFFFFFFFF00000000) >> (CHAR_BIT * 4))
#define PLATFORM_MAKE_WORD(hi, lo) static_cast<uint16_t>((static_cast<uint16_t>(hi) << CHAR_BIT) | static_cast<uint16_t>(lo))
#define PLATFORM_MAKE_DWORD(hi, lo) static_cast<uint32_t>((static_cast<uint32_t>(hi) << (CHAR_BIT * 2)) | static_cast<uint32_t>(lo))
#define PLATFORM_MAKE_QWORD(hi, lo) static_cast<uint64_t>((static_cast<uint64_t>(hi) << (CHAR_BIT * 4)) | static_cast<uint64_t>(lo))


#define PLATFORM_ALIGN(SIZE, ALIGNMENT) \
    ((SIZE + ALIGNMENT - 1) &~ (ALIGNMENT - 1))


// Use these macros after a % in a printf format string
// to get correct 32/64 bit behavior, like this:
// size_t size = records.size();
// printf("%"PRIuS"\n", size);

#if PLATFORM_OS(UNIX)

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#ifndef PRIuS
// printf macros for size_t, in the style of inttypes.h
#if PLATFORM_CPU(X86_64)
#define __PRIS_PREFIX "l"
#else
#define __PRIS_PREFIX
#endif
#define PRIuS __PRIS_PREFIX "u"
#endif

#else

// printf macros for size_t, in the style of inttypes.h
#if PLATFORM_CPU(X86_64)
#define __PRIS_PREFIX "l"
#else
#define __PRIS_PREFIX
#endif

// printf macros for size_t, in the style of inttypes.h
#if PLATFORM_CPU(X86_64)
#define __PRIS_PREFIX "l"
#else
#define __PRIS_PREFIX
#endif

#define PRIdS __PRIS_PREFIX "d"
#define PRIxS __PRIS_PREFIX "x"
#define PRIuS __PRIS_PREFIX "u"
#define PRIXS __PRIS_PREFIX "X"
#define PRIoS __PRIS_PREFIX "o"

#if PLATFORM_CPU(X86)
    #define PRId64 __PRIS_PREFIX "lld"
    #define PRIx64 __PRIS_PREFIX "llx"
    #define PRIu64 __PRIS_PREFIX "llu"
    #define PRIX64 __PRIS_PREFIX "llX"
    #define PRIo64 __PRIS_PREFIX "llo"
#elif PLATFORM_CPU(X86_64)
    #define PRId64 __PRIS_PREFIX "ld"
    #define PRIx64 __PRIS_PREFIX "lx"
    #define PRIu64 __PRIS_PREFIX "lu"
    #define PRIX64 __PRIS_PREFIX "lX"
    #define PRIo64 __PRIS_PREFIX "lo"
#endif

#endif


#if PLATFORM_COMPILER(GCC)
    #define PLATFORM_MAKE_PRIVATE __attribute__((__visibility__("hidden")))
    #define PLATFORM_MAKE_PUBLIC __attribute__((__visibility__("default")))
#elif PLATFORM_COMPILER(MSVC)
    #define PLATFORM_MAKE_PRIVATE
    #if PLATFORM_BUILDING_MODULE
        #define PLATFORM_MAKE_PUBLIC __declspec(dllexport)
    #else
        #define PLATFORM_MAKE_PUBLIC __declspec(dllimport)
    #endif
#endif

#endif /* UTILS_H_140420131006 */
