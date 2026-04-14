import numpy as np
import OpenGL
import glfw

M = np.arange(2, 27)
print(M)

M = M.reshape(5, 5)
print(M)

M[1:-1, 1:-1] = 0
print(M)

M = M @ M
print(M)

v = M[0,:]
print(np.sqrt(np.sum(v**2)))