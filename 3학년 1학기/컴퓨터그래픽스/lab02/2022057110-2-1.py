import glfw
from OpenGL.GL import *
import numpy as np

PType = GL_LINE_LOOP
def render():
    global PType
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()
    glBegin(PType)

    angles = np.linspace(0.0, 2 * np.pi, 12, endpoint=False)
    for angle in angles:
        x = np.cos(angle)
        y = np.sin(angle)
        glVertex2f(x, y)

    glEnd()
    
def key_callback(window, key, scancode, action, mods):
    global PType

    if action == glfw.PRESS:
        if key == glfw.KEY_1:
            PType = GL_POINTS
        elif key == glfw.KEY_2:
            PType = GL_LINES
        elif key == glfw.KEY_3:
            PType = GL_LINE_STRIP
        elif key == glfw.KEY_4:
            PType = GL_LINE_LOOP
        elif key == glfw.KEY_5:
            PType = GL_TRIANGLES
        elif key == glfw.KEY_6:
            PType = GL_TRIANGLE_STRIP
        elif key == glfw.KEY_7:
            PType = GL_TRIANGLE_FAN
        elif key == glfw.KEY_8:
            PType = GL_QUADS
        elif key == glfw.KEY_9:
            PType = GL_QUAD_STRIP
        elif key == glfw.KEY_0:
            PType = GL_POLYGON
            
def main():
    if not glfw.init():
        return
    
    window = glfw.create_window(480, 480, "2022057110-2-1", None, None)
    if not window:
        glfw.terminate()
        return
    
    glfw.make_context_current(window)
    glfw.set_key_callback(window, key_callback)

    while not glfw.window_should_close(window):
        glfw.poll_events()

        render()

        glfw.swap_buffers(window)
    glfw.terminate()

if __name__ == "__main__":
    main()