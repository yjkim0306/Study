import glfw
from OpenGL.GL import *
import numpy as np

gComposedM = np.identity(3)

def render(T):
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()
    # draw coordinate
    glBegin(GL_LINES)
    glColor3ub(255, 0, 0)
    glVertex2fv(np.array([0., 0.]))
    glVertex2fv(np.array([1., 0.]))
    glColor3ub(0, 255, 0)
    glVertex2fv(np.array([0., 0.]))
    glVertex2fv(np.array([0., 1.]))
    glEnd()

    # draw triangle
    glBegin(GL_TRIANGLES)
    glColor3ub(255, 255, 255)
    glVertex2fv((T @ np.array([.0, .5, 1.]))[:-1])
    glVertex2fv((T @ np.array([.0, .0, 1.]))[:-1])
    glVertex2fv((T @ np.array([.5, .0, 1.]))[:-1])
    glEnd()

def key_callback(window, key, scancode, action, mods):
    global gComposedM
    if action == glfw.PRESS or action == glfw.REPEAT: 
        if key == glfw.KEY_Q:
            newM = np.array([[1., 0., -0.1],
                             [0., 1., 0.],
                             [0., 0., 1.]])
            gComposedM = newM @ gComposedM
        elif key == glfw.KEY_E:
            newM = np.array([[1., 0., 0.1],
                             [0., 1., 0.],
                             [0., 0., 1.]])
            gComposedM = newM @ gComposedM
        elif key == glfw.KEY_A:
            rad = np.radians(10)
            newM = np.array([[np.cos(rad), -np.sin(rad), 0.],
                             [np.sin(rad), np.cos(rad), 0.],
                             [0., 0., 1.]])
            gComposedM = gComposedM @ newM
        elif key == glfw.KEY_D:
            rad = np.radians(-10)
            newM = np.array([[np.cos(rad), -np.sin(rad), 0.],
                             [np.sin(rad), np.cos(rad), 0.],
                             [0., 0., 1.]])
            gComposedM = gComposedM @ newM
        elif key == glfw.KEY_1:
            gComposedM = np.identity(3)

def main():
    if not glfw.init():
        return
    window = glfw.create_window(480, 480, "2022057110-3-1", None, None)
    if not window:
        glfw.terminate()
        return
    glfw.make_context_current(window)
    glfw.set_key_callback(window, key_callback)

    while not glfw.window_should_close(window):
        glfw.poll_events()
        render(gComposedM)
        glfw.swap_buffers(window)
    
    glfw.terminate()

if __name__ == "__main__":
    main()