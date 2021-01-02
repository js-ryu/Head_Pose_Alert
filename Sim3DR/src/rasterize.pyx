#cython: language_level=3
cimport numpy as np
cimport cython

# use the Numpy-C-API from Cython
np.import_array()

# cdefine the signature of our c function
cdef extern from "rasterize_kernel.h":
    void _rasterize(
            unsigned char*image, float*vertices, int*triangles, float*colors,
            int ntri, int h, int w, int c, float alpha
    )

    void _get_normal(float *ver_normal, float *vertices, int *triangles, int nver, int ntri)


@cython.boundscheck(False)  # turn off bounds-checking for entire function
@cython.wraparound(False)  # turn off negative index wrapping for entire function
def get_normal(np.ndarray[float, ndim=2, mode = "c"] ver_normal not None,
                   np.ndarray[float, ndim=2, mode = "c"] vertices not None,
                   np.ndarray[int, ndim=2, mode="c"] triangles not None,
                   int nver, int ntri):
    _get_normal(
        <float*> np.PyArray_DATA(ver_normal), <float*> np.PyArray_DATA(vertices), <int*> np.PyArray_DATA(triangles),
        nver, ntri)


@cython.boundscheck(False)  # turn off bounds-checking for entire function
@cython.wraparound(False)  # turn off negative index wrapping for entire function
def rasterize(np.ndarray[unsigned char, ndim=3, mode = "c"] image not None,
              np.ndarray[float, ndim=2, mode = "c"] vertices not None,
              np.ndarray[int, ndim=2, mode="c"] triangles not None,
              np.ndarray[float, ndim=2, mode = "c"] colors not None,
              int ntri, int h, int w, int c, float alpha = 1):
    _rasterize(
        <unsigned char*> np.PyArray_DATA(image), <float*> np.PyArray_DATA(vertices),
        <int*> np.PyArray_DATA(triangles),
        <float*> np.PyArray_DATA(colors),
        ntri, h, w, c, alpha)