-- SPDX-License-Identifier: Apache-2.0

set_project("murmur")
set_version("26.10")

set_toolchains("clang")
add_rules("mode.debug", "mode.release")

target("murmur")
    set_kind("static")

    add_files("src/*.S")
    add_asflags("--target=i386-none-elf", {force = true})

    -- Dependents get include/ automatically
    add_includedirs("include", {public = true})

    -- `xmake install`: headers keep their folder, the linker script goes to share/murmur
    add_headerfiles("include/(murmur/*.h)")
    add_installfiles("linker.ld", {prefixdir = "share/murmur"})