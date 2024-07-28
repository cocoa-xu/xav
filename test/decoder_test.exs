defmodule Xav.DecoderTest do
  use ExUnit.Case, async: true

  @vp8_keyframe <<80, 188, 0, 157, 1, 42, 128, 2, 224, 1, 57, 107, 0, 47, 28, 34, 22, 22, 34, 102,
                  18, 32, 212, 14, 239, 198, 191, 249, 103, 67, 12, 209, 59, 136, 119, 231, 148,
                  71, 190, 250, 205, 56, 167, 146, 195, 27, 246, 83, 183, 213, 135, 180, 90, 89,
                  245, 142, 137, 25, 231, 188, 158, 193, 127, 253, 250, 159, 78, 244, 58, 228,
                  245, 85, 17, 60, 238, 231, 248, 173, 93, 56, 91, 8, 237, 147, 88, 153, 113, 51,
                  216, 209, 121, 113, 94, 108, 141, 79, 9, 69, 31, 25, 96, 117, 112, 75, 211, 110,
                  238, 92, 14, 106, 206, 195, 197, 4, 70, 79, 77, 249, 99, 68, 15, 195, 242, 233,
                  38, 42, 163, 136, 195, 132, 32, 246, 164, 116, 192, 41, 214, 49, 201, 5, 11, 85,
                  98, 239, 249, 93, 48, 135, 223, 250, 190, 150, 98, 51, 157, 195, 88, 142, 143,
                  65, 59, 47, 177, 210, 96, 210, 107, 101, 173, 129, 161, 29, 165, 113, 16, 41,
                  122, 27, 101, 179, 39, 71, 55, 169, 216, 178, 226, 50, 215, 188, 228, 234, 204,
                  196, 240, 38, 134, 50, 101, 13, 137, 128, 221, 34, 83, 63, 67, 223, 196, 25, 8,
                  225, 56, 23, 219, 177, 10, 8, 218, 243, 57, 141, 171, 100, 227, 140, 14, 152,
                  105, 93, 35, 153, 244, 190, 142, 63, 74, 38, 201, 221, 96, 62, 104, 126, 13, 15,
                  79, 137, 138, 205, 173, 133, 205, 115, 114, 142, 132, 68, 17, 52, 48, 14, 105,
                  114, 139, 116, 185, 237, 119, 206, 148, 180, 228, 141, 209, 104, 141, 14, 32,
                  241, 10, 184, 90, 153, 173, 142, 1, 206, 93, 206, 17, 148, 237, 180, 49, 70, 8,
                  152, 211, 167, 131, 244, 59, 117, 113, 82, 128, 130, 124, 64, 50, 202, 107, 152,
                  201, 11, 176, 213, 201, 15, 130, 121, 85, 92, 208, 132, 248, 87, 48, 82, 244,
                  135, 180, 58, 60, 230, 114, 218, 10, 108, 57, 168, 216, 133, 76, 140, 71, 120,
                  138, 173, 21, 34, 251, 4, 167, 220, 87, 152, 179, 71, 134, 80, 66, 105, 203, 62,
                  215, 213, 170, 108, 109, 47, 90, 231, 176, 252, 185, 253, 132, 139, 14, 108, 45,
                  61, 186, 144, 53, 101, 166, 85, 205, 189, 73, 87, 53, 14, 142, 10, 112, 225,
                  172, 10, 125, 178, 32, 128, 50, 10, 253, 31, 211, 23, 74, 138, 221, 141, 71, 46,
                  46, 78, 221, 103, 198, 30, 244, 41, 243, 50, 72, 204, 129, 238, 165, 56, 252, 3,
                  58, 152, 143, 189, 142, 105, 16, 20, 77, 46, 47, 148, 139, 77, 11, 197, 106,
                  167, 38, 123, 110, 249, 169, 133, 235, 148, 221, 126, 90, 8, 123, 23, 207, 177,
                  104, 148, 162, 243, 132, 202, 23, 25, 112, 12, 160, 184, 229, 77, 145, 115, 204,
                  100, 53, 176, 68, 35, 131, 237, 25, 57, 112, 247, 223, 135, 19, 102, 161, 71,
                  223, 40, 204, 61, 206, 180, 196, 33, 19, 86, 191, 156, 234, 73, 124, 250, 252,
                  194, 113, 124, 5, 176, 58, 44, 193, 137, 128, 191, 143, 180, 219, 24, 172, 120,
                  102, 131, 15, 8, 12, 250, 182, 107, 93, 178, 192, 231, 49, 161, 105, 30, 29, 94,
                  38, 232, 49, 24, 99, 101, 115, 202, 237, 127, 60, 222, 168, 5, 14, 226, 74, 29,
                  8, 1, 56, 137, 42, 115, 142, 182, 34, 163, 3, 138, 73, 60, 192, 61, 136, 197,
                  151, 218, 90, 103, 155, 78, 37, 242, 147, 118, 212, 19, 37, 164, 85, 15, 122,
                  108, 190, 66, 167, 233, 44, 7, 227, 237, 27, 136, 167, 172, 204, 118, 115, 144,
                  17, 104, 95, 94, 165, 14, 123, 199, 69, 56, 127, 232, 29, 150, 219, 252, 141,
                  92, 95, 4, 8, 183, 244, 72, 200, 33, 246, 171, 150, 162, 120, 4, 175, 140, 94,
                  38, 211, 201, 203, 239, 185, 159, 148, 8, 246, 238, 143, 183, 58, 164, 132, 245,
                  213, 67, 69, 42, 189, 248, 227, 25, 52, 97, 151, 75, 42, 212, 104, 249, 72, 39,
                  22, 56, 252, 155, 173, 172, 126, 154, 5, 68, 60, 181, 153, 22, 214, 200, 174,
                  70, 160, 113, 250, 157, 52, 34, 195, 233, 3, 147, 62, 78, 34, 218, 164, 183,
                  230, 105, 30, 183, 50, 160, 250, 159, 73, 33, 241, 58, 22, 169, 195, 203, 255,
                  3, 41, 102, 213, 119, 162, 98, 84, 37, 219, 233, 86, 243, 185, 177, 153, 69,
                  212, 97, 239, 27, 56, 173, 210, 59, 76, 88, 18, 93, 185, 72, 104, 215, 221, 22,
                  131, 216, 19, 86, 210, 0, 187, 47, 2, 182, 157, 40, 171, 87, 68, 191, 230, 167,
                  225, 38, 32, 153, 78, 165, 190, 187, 240, 94, 35, 28, 217, 35, 40, 236, 218, 81,
                  252, 42, 39, 14, 222, 254, 98, 231, 102, 168, 176, 147, 225, 19, 5, 137, 197, 9,
                  218, 73, 143, 186, 225, 176, 221, 53, 21, 14, 237, 138, 136, 193, 21, 87, 144,
                  221, 236, 202, 69, 2, 101, 197, 203, 10, 190, 80, 43, 18, 113, 167, 45, 162, 22,
                  26, 154, 153, 81, 76, 242, 106, 217, 93, 193, 112, 163, 13, 223, 161, 124, 93,
                  246, 67, 224, 190, 60, 143, 128, 188, 110, 191, 30, 25, 251, 221, 128, 76, 176,
                  220, 252, 194, 248, 170, 113, 243, 187, 213, 209, 135, 102, 182, 167, 255, 139,
                  77, 37, 173, 195, 231, 67, 182, 172, 121, 238, 104, 213, 120, 61, 138, 193, 190,
                  8, 15, 82, 60, 172, 68, 43, 14, 57, 244, 32, 41, 212, 196, 186, 155, 252, 85,
                  172, 235, 68, 113, 152, 136, 209, 158, 171, 180, 209, 165, 157, 124, 125, 4,
                  217, 43, 140, 143, 204, 223, 115, 186, 33, 220, 176, 170, 2, 222, 49, 4, 52,
                  220, 148, 39, 30, 135, 243, 235, 248, 88, 242, 92, 102, 171, 4, 251, 11, 134,
                  165, 42, 32, 161, 12, 25, 12, 128, 60, 190, 147, 184, 251, 81, 203, 247, 15,
                  234, 230, 68, 222, 179, 179, 66, 167, 126, 237, 32, 111, 50, 98, 247, 225, 26,
                  117, 133, 98, 42, 177, 25, 167, 137, 172, 47, 91, 123, 230, 176, 198, 252, 187,
                  160, 25, 13, 249, 103, 118, 195, 141, 217, 138, 197, 11, 249, 44, 79, 102, 188,
                  149, 31, 158, 29, 145, 155, 68, 159, 158, 223, 250, 173, 98, 148, 129, 72, 149,
                  21, 193, 171, 112, 191, 88, 26, 152, 211, 14, 134, 173, 187, 250, 189, 47, 28,
                  156, 160, 241, 65, 108, 91, 112, 198, 206, 197, 140, 50, 217, 206, 196, 93, 250,
                  141, 63, 57, 214, 225, 8, 209, 163, 139, 15, 25, 255, 150, 4, 29, 252, 181, 48,
                  193, 6, 135, 133, 7, 89, 233, 178, 167, 10, 70, 31, 91, 251, 216, 141, 82, 4,
                  214, 30, 44, 97, 35, 204, 161, 149, 108, 166, 206, 146, 149, 236, 145, 161, 72,
                  105, 151, 194, 125, 101, 81, 186, 15, 23, 64, 183, 98, 79, 154, 159, 233, 107,
                  79, 212, 127, 131, 125, 60, 43, 90, 130, 18, 229, 224, 1, 105, 105, 84, 51, 227,
                  80, 236, 195, 190, 138, 240, 185, 113, 67, 78, 224, 65, 241, 106, 110, 193, 210,
                  40, 102, 98, 120, 1, 239, 92, 83, 180, 208, 116, 248, 17, 13, 178, 139, 232,
                  227, 140, 56, 114, 232, 63, 83, 83, 211, 205, 11, 213, 20, 239, 66, 35, 133, 86,
                  25, 158, 164, 156, 88, 62, 106, 109, 229, 218, 71, 3, 249, 232, 179, 4, 129, 94,
                  13, 221, 243, 191, 176, 143, 42, 230, 205, 184, 43, 97, 230, 123, 195, 50, 157,
                  226, 20, 9, 34, 127, 90, 97, 236, 50, 95, 88, 222, 224, 13, 86, 221, 156, 90,
                  24, 241, 9, 127, 193, 53, 164, 203, 217, 222, 16, 142, 168, 13, 57, 44, 58, 149,
                  40, 105, 55, 148, 55, 149, 52, 72, 3, 5, 106, 147, 198, 104, 103, 34, 180, 92,
                  253, 87, 0, 34, 132, 177, 186, 225, 99, 133, 90, 70, 215, 202, 133, 87, 119,
                  163, 161, 188, 242, 24, 65, 173, 248, 170, 202, 43, 244, 29, 62, 206, 99, 212,
                  34, 141, 215, 201, 9, 91, 136, 18, 129, 33, 216, 15, 254, 211, 41, 92, 35, 78,
                  28, 86, 243, 141, 142, 55, 162, 114, 6, 23, 30, 214, 120, 8, 136, 191, 77, 27,
                  79, 81, 85, 116, 150, 171, 113, 130, 6, 218, 24, 105, 162, 182, 82, 136, 172,
                  68, 85, 175, 215, 62, 60, 253, 7, 150, 27, 46, 30, 109, 177, 174, 77, 51, 167,
                  100, 0, 28, 46, 103, 94, 236, 140, 129, 28, 116, 205, 45, 85, 236, 234, 240, 7,
                  158, 92, 131, 23, 244, 215, 192, 156, 58, 1, 205, 157, 171, 8, 179, 132, 151,
                  254, 201, 80, 207, 206, 86, 43, 27, 103, 16, 96, 17, 234, 28, 19, 178, 141, 12,
                  231, 244, 180, 224, 254, 170, 116, 14, 21, 119, 90, 99, 69, 30, 122, 152, 173,
                  250, 198, 250, 129, 127, 122, 130, 236, 229, 54, 143, 245, 226, 236, 106, 85,
                  29, 7, 93, 149, 211, 204, 235, 153, 151, 19, 170, 121, 91, 74, 24, 0, 219, 22,
                  226, 118, 227, 209, 248, 162, 170, 1, 49, 79, 111, 236, 21, 24, 53, 58, 190, 94,
                  137, 162, 96, 212, 50, 129, 222, 199, 115, 170, 113, 18, 119, 54, 103, 140, 28,
                  21, 135, 227, 122, 73, 33, 209, 120, 44, 46, 29, 105, 153, 191, 142, 252, 9,
                  249, 6, 182, 63, 153, 146, 84, 231, 30, 148, 44, 59, 24, 237, 104, 216, 162, 22,
                  206, 32, 158, 167, 144, 123, 35, 1, 135, 164, 144, 224, 59, 204, 178, 14, 248,
                  24, 66, 72, 161, 136, 144, 154, 250, 148, 99, 42, 211, 161, 74, 133, 104, 246,
                  148, 180, 29, 85, 1, 35, 121, 140, 65, 87, 108, 43, 135, 93, 147, 56, 104, 44,
                  4, 124, 214, 179, 166, 146, 31, 155, 28, 235, 123, 77, 113, 194, 82, 139, 74, 6,
                  85, 57, 9, 234, 67, 9, 109, 43, 182, 245, 113, 140, 100, 149, 204, 230, 11, 72,
                  153, 6, 177, 145, 194, 30, 193, 97, 215, 80, 1, 185, 141, 31, 42, 164, 172, 40,
                  103, 74, 186, 228, 239, 81, 49, 38, 71, 58, 5, 184, 235, 77, 73, 31, 56, 177,
                  102, 236, 44, 148, 84, 204, 177, 142, 150, 222, 174, 52, 193, 245, 248, 12, 92,
                  198, 70, 171, 219, 20, 75, 77, 117, 68, 170, 214, 47, 229, 18, 77, 52, 215, 28,
                  190, 90, 161, 64, 52, 182, 42, 140, 218, 183, 212, 187, 116, 54, 153, 99, 184,
                  69, 135, 172, 127, 234, 210, 216, 29, 107, 22, 121, 116, 147, 5, 20, 46, 123,
                  71, 108, 68, 134, 49, 137, 36, 79, 226, 190, 223, 78, 22, 96, 211, 208, 106, 62,
                  187, 0, 120, 196, 137, 54, 15, 195, 1, 241, 131, 129, 62, 232, 224, 99, 113, 17,
                  189, 58, 217, 13, 238, 82, 213, 197, 130, 209, 159, 59, 54, 142, 116, 35, 44,
                  147, 183, 8, 98, 74, 182, 89, 232, 79, 31, 195, 81, 79, 138, 56, 161, 250, 222,
                  15, 104, 205, 223, 249, 218, 72, 106, 101, 105, 11, 230, 46, 116, 234, 202, 187,
                  208, 11, 235, 125, 145, 85, 35, 235, 66, 203, 60, 39, 197, 10, 119, 14, 230, 78,
                  11, 86, 67, 109, 143, 245, 153, 110, 128, 136, 122, 97, 174, 73, 185, 169, 70,
                  183, 125, 129, 184, 180, 0, 0, 54, 200, 216, 241, 53, 74, 31, 97, 250, 49, 106,
                  140, 213, 229, 113, 14, 133, 170, 103, 9, 111, 125, 70, 126, 193, 134, 49, 176,
                  104, 44, 39, 184, 202, 189, 117, 216, 78, 216, 212, 84, 59, 35, 230, 223, 213,
                  133, 0, 75, 113, 111, 106, 125, 153, 242, 76, 4, 18, 161, 158, 100, 192, 89,
                  170, 153, 146, 62, 45, 251, 43, 216, 208, 230, 17, 43, 101, 50, 183, 42, 212,
                  37, 123, 76, 50, 240, 82, 84, 112, 12, 243, 194, 35, 49, 76, 28, 75, 89, 104,
                  107, 23, 89, 14, 226, 70, 60, 79, 67, 255, 193, 171, 114, 41, 50, 20, 133, 55,
                  92, 117, 109, 196, 49, 224, 27, 144, 142, 72, 20, 114, 250, 208, 107, 226, 225,
                  55, 41, 105, 102, 142, 242, 253, 206, 110, 87, 11, 234, 56, 251, 85, 231, 45, 1,
                  173, 4, 216, 17, 16, 49, 139, 84, 177, 100, 216, 220, 129, 248, 161, 18, 156,
                  162, 149, 128, 145, 110, 91, 226, 16, 246, 173, 128, 162, 215, 216, 118, 132,
                  99, 197, 157, 173, 150, 202, 151, 40, 56, 27, 7, 40, 226, 159, 18, 77, 186, 124,
                  175, 205, 198, 247, 154, 193, 254, 235, 13, 213, 45, 229, 166, 194, 28, 5, 228,
                  191, 102, 141, 21, 101, 229, 36, 223, 231, 20, 110, 26, 17, 64, 237, 85, 247,
                  198, 194, 204, 160, 2, 27, 246, 210, 18, 144, 10, 194, 249, 254, 119, 15, 22,
                  26, 9, 31, 136, 86, 236, 25, 214, 65, 134, 11, 108, 188, 252, 180, 190, 98, 238,
                  126, 193, 7, 234, 219, 47, 102, 186, 83, 249, 109, 248, 12, 84, 0, 40, 247, 169,
                  8, 131, 183, 214, 128, 170, 250, 6, 179, 220, 6, 57, 178, 3, 167, 125, 123, 176,
                  171, 21, 33, 152, 92, 65, 180, 89, 101, 237, 125, 219, 7, 100, 195, 80, 81, 29,
                  160, 109, 121, 179, 215, 176, 232, 230, 218, 93, 197, 90, 2, 114, 31, 197, 80,
                  19, 240, 232, 255, 189, 246, 98, 255, 170, 107, 112, 106, 238, 27, 24, 135, 141,
                  10, 25, 251, 109, 224, 70, 151, 182, 64, 92, 105, 63, 61, 226, 113, 193, 243,
                  235, 51, 16, 48, 253, 209, 160, 124, 10, 61, 192, 12, 125, 57, 16, 177, 123,
                  213, 22, 120, 109, 9, 217, 28, 161, 237, 7, 217, 22, 206, 88, 46, 49, 91, 95,
                  11, 39, 49, 32, 69, 92, 224, 236, 170, 4, 162, 61, 248, 80, 94, 16, 104, 16, 34,
                  192, 214, 24, 141, 37, 137, 88, 112, 49, 56, 110, 179, 90, 4, 241, 142, 35, 107,
                  200, 206, 129, 170, 138, 24, 107, 138, 171, 87, 243, 29, 37, 158, 75, 167, 37,
                  232, 13, 218, 97, 17, 104, 12, 85, 38, 57, 31, 103, 54, 149, 30, 62, 47, 204,
                  209, 68, 27, 179, 28, 15, 194, 142, 162, 81, 253, 80, 153, 209, 205, 1, 125, 24,
                  74, 3, 251, 117, 144, 180, 238, 179, 24, 43, 139, 155, 53, 216, 231, 49, 173,
                  96, 39, 203, 249, 129, 199, 170, 246, 18, 76, 195, 77, 179, 58, 200, 154, 15,
                  16, 68, 1, 236, 133, 206, 137, 186, 125, 203, 164, 92, 180, 155, 194, 69, 76,
                  144, 98, 64, 249, 0, 173, 26, 217, 108, 225, 47, 167, 144, 60, 187, 117, 92,
                  105, 152, 35, 123, 33, 30, 137, 17, 94, 135, 156, 169, 60, 123, 45, 14, 22, 178,
                  89, 57, 130, 180, 243, 12, 73, 71, 181, 196, 50, 226, 231, 144, 77, 138, 222,
                  212, 39, 72, 148, 167, 131, 242, 101, 77, 141, 193, 4, 241, 118, 203, 130, 18,
                  141, 51, 169, 211, 78, 134, 166, 187, 63, 79, 216, 178, 173, 138, 104, 48, 200,
                  15, 239, 38, 67, 74, 219, 28, 51, 40, 170, 219, 164, 88, 186, 236, 163, 254,
                  191, 181, 13, 151, 18, 108, 46, 134, 189, 103, 94, 28, 88, 181, 201, 86, 76, 1,
                  7, 59, 35, 39, 180, 63, 183, 100, 111, 235, 158, 182, 19, 93, 213, 87, 76, 10,
                  151, 207, 121, 218, 226, 139, 127, 21, 233, 63, 24, 192, 252, 85, 171, 107, 165,
                  207, 212, 246, 139, 84, 203, 177, 203, 51, 118, 150, 1, 209, 200, 219, 202, 59,
                  164, 222, 24, 121, 174, 101, 138, 176, 255, 164, 138, 154, 106, 18, 21, 136,
                  193, 250, 229, 170, 157, 86, 106, 26, 55, 180, 254, 107, 232, 123, 126, 16, 221,
                  9, 12, 116, 217, 229, 204, 11, 130, 195, 93, 33, 219, 224, 43, 200, 120, 244,
                  207, 173, 77, 35, 155, 125, 68, 60, 125, 112, 144, 175, 121, 208, 105, 249, 144,
                  217, 210, 41, 173, 19, 117, 92, 219, 249, 115, 219, 181, 194, 214, 100, 84, 173,
                  76, 18, 176, 45, 182, 35, 132, 83, 145, 141, 15, 152, 67, 171, 68, 204, 147,
                  219, 31, 222, 75, 162, 23, 6, 171, 114, 118, 97, 93, 201, 19, 101, 208, 182, 24,
                  16, 188, 80, 113, 103, 94, 42, 250, 14, 244, 156, 51, 184, 188, 228, 11, 162,
                  253, 54, 95, 0, 250, 143, 251, 22, 129, 181, 146, 75, 60, 67, 110, 173, 110,
                  134, 139, 153, 145, 90, 64, 226, 126, 14, 144, 232, 218, 141, 153, 48, 163, 83,
                  49, 236, 13, 17, 11, 56, 62, 136, 1, 63, 95, 118, 49, 49, 100, 2, 203, 217, 31,
                  32, 141, 14, 144, 0>>

  @vp8_frame <<113, 27, 0, 227, 99, 175, 184, 147, 248, 30, 192, 95, 64, 166, 192, 191, 208, 7,
               132, 38, 186, 200, 217, 201, 141, 2, 254, 56, 91, 187, 127, 94, 174, 121, 213, 17,
               58, 149, 133, 112, 140, 65, 76, 115, 78, 81, 91, 9, 205, 177, 242, 71, 187, 23,
               190, 12, 164, 107, 84, 36, 86, 122, 106, 96, 58, 241, 248, 8, 240, 15, 2, 12, 231,
               51, 156, 140, 18, 135, 111, 13, 73, 192, 148, 230, 131, 29, 20, 72, 4, 215, 212,
               134, 76, 191, 182, 249, 110, 58, 113, 118, 107, 193, 209, 4, 105, 195, 226, 137,
               208, 188, 78, 43, 238, 90, 37, 68, 221, 199, 148, 3, 92, 244, 212, 101, 16, 143, 7,
               166, 121, 197, 192, 141, 176, 17, 182, 2, 54, 192, 70, 216, 8, 219, 1, 27, 96, 35,
               108, 4, 109, 128, 141, 176, 17, 78, 35, 108, 4, 109, 128, 145, 160, 106, 70, 216,
               8, 192, 128, 155, 23, 16, 148, 9, 158, 75, 62, 103, 230, 84, 114, 179, 210, 117,
               187, 81, 74, 95, 94, 54, 11, 139, 181, 254, 202, 56, 241, 21, 119, 237, 191, 220,
               115, 109, 175, 129, 26, 38, 220, 112, 141, 241, 182, 139, 24, 152, 45, 1, 93, 166,
               93, 46, 187, 32, 145, 117, 169, 77, 32, 175, 203, 27, 209, 14, 181, 244, 136, 34,
               27, 156, 15, 222, 141, 141, 39, 47, 228, 197, 93, 254, 193, 183, 77, 9, 193, 123,
               187, 114, 204, 144, 33, 17, 223, 207, 106, 198, 221, 188, 80, 38, 52, 96, 70, 10,
               90, 120, 92, 15, 46, 10, 109, 160, 214, 95, 10, 155, 83, 203, 168, 47, 122, 237,
               29, 224, 240, 100, 3, 51, 51, 143, 33, 31, 143, 173, 116, 49, 159, 68, 12, 27, 75,
               22, 202, 111, 106, 126, 82, 47, 108, 219, 254, 148, 1, 53, 206, 147, 47, 57, 210,
               74, 109, 225, 250, 88, 204, 211, 212, 73, 183, 23, 153, 145, 191, 219, 243, 155,
               33, 100, 92, 43, 135, 157, 93, 124, 30, 202, 107, 39, 236, 71, 179, 23, 165, 191,
               109, 220, 230, 137, 113, 145, 153, 248, 100, 215, 148, 46, 172, 234, 1, 130, 241,
               5, 236, 11, 190, 213, 45, 254, 106, 95, 253, 37, 73, 237, 193, 79, 19, 203, 230,
               93, 200, 22, 40, 239, 242, 94, 78, 3, 139, 46, 253, 68, 131, 77, 215, 231, 166, 83,
               118, 67, 112, 60, 181, 15, 244, 144, 192, 75, 96, 209, 110, 49, 43, 93, 50, 8, 100,
               157, 143, 101, 226, 94, 173, 148, 126, 71, 70, 128, 174, 141, 234, 41, 43, 43, 158,
               140, 82, 93, 84, 170, 53, 54, 65, 69, 85, 222, 122, 165, 210, 70, 67, 20, 98, 101,
               105, 224, 152, 223, 178, 20, 126, 153, 130, 131, 64, 32, 247, 215, 119, 54, 132,
               251, 218, 90, 75, 141, 103, 8, 199, 249, 193, 26, 138, 81, 19, 236, 111, 185, 146,
               134, 84, 58, 244, 77, 13, 3, 210, 96, 138, 44, 89, 148, 99, 152, 132, 20, 178, 75,
               6, 163, 164, 156, 253, 23, 132, 202, 168, 160, 145, 16, 209, 165, 78, 98, 244, 118,
               60, 3, 137, 108, 170, 188, 249, 163, 67, 249, 21, 47, 53, 49, 38, 137, 248, 184,
               124, 81, 181, 47, 213, 148, 51, 162, 15, 202, 105, 3, 196, 101, 12, 254, 154, 230,
               218, 109, 0, 169, 34, 141, 182, 122, 208, 245, 5, 37, 168, 80, 69, 204, 81, 238,
               112, 241, 73, 205, 110, 143, 120, 119, 118, 246, 226, 32, 29, 225, 244, 63, 205,
               115, 194, 203, 172, 102, 69, 111, 44, 136, 95, 212, 20, 201, 200, 174, 162, 213,
               53, 140, 120, 140, 68, 229, 63, 242, 24, 230, 105, 84, 163, 154, 241, 184, 237,
               246, 186, 130, 133, 63, 18, 199, 196, 141, 162, 82, 232, 207, 252, 53, 108, 22,
               156, 248, 19, 202, 251, 52, 31, 129, 192, 146, 74, 89, 81, 143, 124, 219, 239, 230,
               49, 101, 21, 247, 80, 129, 162, 125, 98, 200, 197, 197, 126, 161, 54, 103, 53, 78,
               58, 207, 224, 77, 31, 71, 112, 190, 168, 177, 74, 2, 62, 44, 53, 5, 122, 97, 173,
               171, 92, 137, 60, 52, 211, 222, 248, 221, 88, 240, 131, 158, 225, 129, 237, 97, 10,
               123, 46, 85, 130, 163, 224, 250, 178, 34, 142, 228, 109, 48, 112, 66, 169, 110, 6,
               46, 138, 144, 189, 145, 241, 158, 168, 178, 71, 103, 177, 5, 227, 243, 113, 16,
               112, 47, 121, 57, 100, 76, 148, 226, 250, 151, 48, 20, 26, 117, 239, 151, 97, 91,
               126, 246, 15, 22, 128, 147, 167, 189, 208, 190, 248, 152, 239, 180, 233, 71, 222,
               198, 145, 32, 90, 162, 218, 163, 17, 0, 60, 232, 8, 119, 13, 129, 15, 27, 157, 182,
               25, 171, 98, 83, 80, 89, 135, 9, 119, 252, 164, 132, 148, 150, 15, 102, 176, 144,
               234, 138, 103, 151, 7, 54, 167, 246, 212, 57, 245, 250, 99, 60, 58, 56, 204, 47,
               220, 215, 109, 218, 216, 147, 246, 135, 3, 219, 219, 124, 109, 8, 187, 225, 86, 42,
               147, 101, 65, 155, 43, 48, 19, 163, 127, 121, 96, 127, 160, 233, 78, 247, 100, 84,
               45, 66, 228, 173, 255, 166, 245, 118, 21, 121, 90, 20, 69, 255, 228, 187, 229, 179,
               62, 33, 31, 50, 216, 156, 70, 28, 255, 92, 105, 175, 105, 134, 33, 203, 99, 91, 83,
               240, 155, 98, 107, 131, 89, 56, 242, 118, 49, 16, 29, 130, 234, 0, 180, 138, 0, 93,
               8, 218, 127, 183, 34, 145, 237, 130, 123, 17, 80, 205, 233, 199, 169, 140, 71, 52,
               247, 65, 8, 148, 55, 159, 88, 190, 170, 186, 31, 205, 141, 115, 233, 3, 77, 206,
               160, 61, 29, 53, 148, 218, 64, 49, 196, 150, 164, 231, 238, 245, 183, 223, 71, 223,
               185, 21, 133, 102, 136, 181, 176, 220, 209, 63, 130, 210, 237, 191, 108, 3, 109,
               60, 210, 245, 81, 168, 156, 188, 66, 98, 242, 229, 227, 7, 159, 85, 64, 211, 34,
               168, 215, 177, 22, 224, 19, 93, 96, 177, 229, 161, 48, 17, 27, 65, 176, 138, 141,
               155, 142, 70, 32, 15, 124, 231, 226, 181, 118, 217, 198, 93, 250, 116, 141, 217,
               164, 55, 11, 231, 103, 76, 193, 212, 188, 58, 160, 98, 183, 244, 83, 21, 208, 116,
               117, 29, 179, 177, 21, 53, 151, 245, 168, 203, 221, 48, 102, 71, 34, 180, 160, 176,
               202, 233, 21, 77, 17, 219, 9, 172, 60, 246, 143, 240, 107, 97, 94, 171, 147, 246,
               166, 31, 5, 173, 235, 234, 65, 170, 64, 50, 195, 68, 165, 122, 19, 148, 190, 187,
               119, 41, 13, 45, 63, 74, 29, 196, 183, 111, 243, 187, 194, 157, 188, 205, 106, 119,
               184, 54, 254, 140, 47, 216, 53, 167, 128, 194, 9, 37, 58, 68, 197, 38, 5, 23, 154,
               114, 174, 107, 132, 133, 210, 149, 84, 125, 139, 72, 226, 236, 167, 99, 158, 64,
               196, 145, 137, 184, 100, 97, 24, 75, 145, 203, 85, 22, 79, 159, 212, 6, 34, 49, 44,
               165, 69, 71, 19, 183, 200, 46, 202, 108, 16, 43, 126, 104, 81, 141, 161, 4, 48, 76,
               55, 142, 63, 240, 40, 147, 102, 104, 231, 88, 82, 58, 149, 50, 239, 244, 0, 195,
               108, 187, 105, 144, 52, 161, 109, 14, 253, 78, 62, 79, 118, 236, 11, 125, 207, 49,
               172, 123, 243, 81, 214, 0, 37, 74, 252, 38, 113, 5, 218, 31, 148, 35, 7, 149, 165,
               47, 81, 112, 36, 37, 110, 47, 58, 118, 186, 191, 203, 248, 224, 152, 132, 72, 28,
               94, 142, 155, 246, 129, 78, 216, 169, 169, 202, 220, 233, 31, 200, 46, 39, 166, 95,
               56, 128, 127, 83, 240, 21, 172, 228, 86, 81, 136, 65, 204, 219, 149, 80, 113, 136,
               51, 160, 35, 15, 189, 30, 239, 230, 103, 108, 232, 196, 136, 69, 69, 7, 227, 49,
               161, 241, 247, 140, 29, 70, 234, 87, 42, 190, 199, 34, 219, 201, 70, 145, 227, 237,
               71, 90, 36, 11, 94, 119, 4, 193, 9, 206, 177, 115, 135, 111, 232, 154, 213, 63, 38,
               210, 71, 215, 114, 161, 1, 72, 130, 135, 86, 50, 237, 52, 235, 161, 73, 41, 93,
               128, 143, 100, 201, 181, 23, 20, 209, 152, 163, 93, 214, 159, 10, 99, 39, 63, 226,
               7, 35, 142, 143, 195, 149, 158, 31, 113, 211, 70, 150, 100, 251, 174, 147, 248, 57,
               197, 182, 127, 97, 169, 4, 188, 63, 180, 193, 14, 155, 212, 244, 32, 195, 185, 34,
               124, 89, 101, 106, 85, 50, 113, 232, 148, 231, 73, 28, 124, 193, 152, 168, 63, 52,
               64, 205, 26, 205, 218, 107, 85, 155, 196, 178, 213, 15, 90, 193, 68, 221, 128, 128,
               23, 43, 52, 152, 253, 78, 32, 8, 71, 255, 228, 82, 174, 34, 7, 3, 222, 34, 77, 68,
               249, 116, 60, 129, 23, 179, 75, 220, 112, 37, 79, 201, 124, 233, 153, 225, 251, 48,
               39, 198, 118, 97, 45, 129, 210, 87, 113, 186, 223, 226, 211, 33, 194, 75, 129, 46,
               122, 164, 228, 85, 9, 11, 155, 105, 17, 215, 246, 37, 6, 75, 123, 145, 243, 35, 8,
               166, 61, 29, 211, 157, 217, 97, 173, 252, 28, 107, 118, 151, 72, 122, 254, 255, 5,
               178, 132, 161, 175, 223, 188, 0, 160, 117, 125, 65, 160, 244, 121, 229, 200, 192,
               159, 21, 81, 91, 126, 44, 86, 131, 155, 31, 39, 41, 75, 75, 214, 44, 66, 249, 107,
               211, 200, 204, 73, 151, 142, 124, 238, 111, 42, 180, 215, 125, 23, 149, 243, 29,
               70, 228, 225, 222, 119, 118, 57, 216, 136, 45, 34, 190, 172, 145, 122, 145, 212,
               68, 76, 182, 53, 117, 93, 208, 166, 223, 215, 39, 170, 77, 178, 244, 228, 15, 102,
               235, 16, 222, 224, 199, 42, 213, 88, 210, 106, 34, 142, 6, 79, 36, 72, 252, 225,
               233, 4, 251, 111, 195, 87, 210, 14, 88, 137, 95, 75, 233, 68, 161, 52, 66, 144,
               152, 184, 210, 94, 122, 186, 107, 79, 36, 13, 139, 203, 224, 17, 86, 29, 161, 222,
               149, 118, 208, 195, 20, 81, 71, 154, 21, 206, 39, 49, 244, 210, 13, 24, 7, 239, 20,
               15, 160, 2, 250, 212, 65, 61, 243, 90, 63, 68, 193, 38, 187, 247, 69, 179, 0, 193,
               123, 220, 87, 219, 239, 160, 39, 104, 219, 123, 170, 165, 3, 90, 238, 78, 204, 237,
               97, 245, 132, 242, 66, 233, 31, 248, 157, 152, 105, 29, 215, 43, 144, 188, 93, 21,
               189, 153, 239, 52, 171, 162, 19, 58, 200, 80, 35, 215, 177, 168, 199, 195, 241,
               201, 218, 168, 149, 71, 44, 45, 32, 210, 123, 40, 49, 128, 45, 39, 218, 71, 56, 81,
               171, 91, 192, 138, 45, 210, 222, 95, 176, 78, 250, 173, 8, 178, 175, 37, 195, 139,
               204, 209, 62, 212, 129, 253, 48, 153, 77, 67, 196, 165, 46, 34, 53, 202, 246, 66,
               26, 58, 131, 73, 4, 128, 87, 122, 26, 183, 33, 35, 189, 79, 32, 244, 176, 146, 172,
               111, 142, 216, 117, 159, 124, 27, 28, 109, 90, 250, 72, 237, 19, 110, 124, 122,
               138, 148, 104, 243, 245, 220, 124, 157, 132, 105, 120, 55, 162, 70, 22, 27, 207,
               250, 30, 232, 155, 62, 112, 161, 130, 151, 153, 60, 106, 189, 18, 240, 42, 202,
               163, 215, 207, 53, 45, 161, 215, 215, 16, 169, 97, 55, 205, 151, 101, 54, 117, 247,
               157, 108, 185, 56, 27, 101, 84, 150, 2, 37, 191, 153, 173, 174, 228, 68, 0, 217,
               21, 212, 116, 246, 155, 111, 11, 160, 0>>

  @opus_frame <<120, 12, 65, 10, 226, 218, 78, 44, 178, 170, 67, 85, 217, 117, 65, 205, 95, 118,
                107, 76, 36, 55, 13, 188, 245, 18, 11, 194, 57, 176, 212, 48, 198, 41, 85, 192,
                142, 204, 5, 106, 217, 175, 162, 62, 128, 161, 69, 136, 234, 30, 43, 165, 152,
                104, 143>>

  test "new/0" do
    assert decoder = Xav.Decoder.new(:vp8)
    assert is_reference(decoder)

    assert decoder = Xav.Decoder.new(:opus)
    assert is_reference(decoder)

    assert_raise(ErlangError, fn -> Xav.Decoder.new(:unknown) end)
  end

  describe "decode/2" do
    test "audio" do
      decoder = Xav.Decoder.new(:opus)

      assert {:ok, %Xav.Frame{samples: 960, pts: 0, format: :flt}} =
               Xav.Decoder.decode(decoder, @opus_frame)
    end

    test "video keyframe" do
      decoder = Xav.Decoder.new(:vp8)

      assert {:ok, %Xav.Frame{width: 640, height: 480, pts: 0, format: :rgb}} =
               Xav.Decoder.decode(decoder, @vp8_keyframe)
    end

    test "video without prior keyframe" do
      decoder = Xav.Decoder.new(:vp8)

      assert {:error, :no_keyframe} = Xav.Decoder.decode(decoder, @vp8_frame)
    end
  end
end
