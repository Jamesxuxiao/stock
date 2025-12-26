# Base image
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Notebook <xuxiao.ca@gmail.com>"

# Use bash as the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Install dependencies and Microsoft packages
RUN apt-get update && \
    apt-get install -y ca-certificates gnupg curl unixodbc-dev && \
    update-ca-certificates && \
    curl --retry 3 --retry-delay 5 https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl --retry 3 --retry-delay 5 https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools && \
    apt-get install -y --no-install-recommends fonts-dejavu tzdata gfortran gcc scilab pari-gp \
    libpari-dev sagemath sagemath-jupyter libgmp-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/mssql-release.list

# Install mamba and Python packages
RUN conda install -c conda-forge mamba --yes --quiet && \
    mamba install --channel conda-forge --yes --quiet \
        'jupytext' 'plotly' 'folium' 'geopandas' 'python-slugify' 'turbodbc' \
        'sqlite' 'pysqlite3' && \
    conda clean --all -f -y

# Configure JupyterLab and extensions
RUN jupyter labextension install plotly --no-build && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    rm -rf "/home/${NB_USER}/.cache/yarn" "/home/${NB_USER}/.node-gyp" && \
    fix-permissions "${CONDA_DIR}" "/home/${NB_USER}"

# Fix SageMath kernel path
RUN sed -i 's/"\/usr\/bin\/sage"/"env", "PATH=\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin", "\/usr\/bin\/sage"/' /usr/share/jupyter/kernels/sagemath/kernel.json

# Install from requirements.txt
COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Set permissions for the final user
RUN chown -R ${NB_UID}:${NB_GID} /home/${NB_USER}

# Final user setup
USER $NB_UID
