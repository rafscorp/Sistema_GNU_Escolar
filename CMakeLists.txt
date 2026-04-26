cmake_minimum_required(VERSION 3.10)
project(Cad_Isow C)

# Define o padrão do C
set(CMAKE_C_STANDARD 11)

# 1. Busca a biblioteca X11 no sistema (essencial para a KylGUI)
find_package(X11 REQUIRED)

# 2. Define onde estão os seus headers (.h)
include_directories(includes)

# 3. Lista apenas os arquivos de implementação (.c)
# Não é obrigatório listar os .h no add_executable, mas ajuda no CLion
set(SOURCE_FILES
        src/main.c
)

# 4. Cria o executável
add_executable(Cad_Isow ${SOURCE_FILES})

# 5. Linka a biblioteca X11 ao seu executável
target_link_libraries(Cad_Isow PRIVATE ${X11_LIBRARIES})
target_link_libraries(Cad_Isow PRIVATE ${X11_LIBRARIES} pthread)